"""Shared NvChad-style cheatsheet rendering (cards, masonry, pager, fzf)."""
import os, re, select, shutil, signal, subprocess, sys

ANSI = re.compile(r"\x1b\[[0-9;]*m")
COLOR = True

# Catppuccin Mocha
PAL = dict(text=(205, 214, 244), sub=(166, 173, 200), dim=(108, 112, 134), base=(17, 17, 27),
           mauve=(203, 166, 247), blue=(137, 180, 250), green=(166, 227, 161), peach=(250, 179, 135),
           red=(243, 139, 168), teal=(148, 226, 213), yellow=(249, 226, 175), pink=(245, 194, 231))
ACCENTS = ["blue", "mauve", "green", "peach", "teal", "pink", "yellow", "red"]

def fg(name, s, bold=False):
    if not COLOR:
        return s
    r, g, b = PAL[name]
    return f"\x1b[{'1;' if bold else ''}38;2;{r};{g};{b}m{s}\x1b[0m"


def badge(name, s):
    if not COLOR:
        return s
    r, g, b = PAL[name]
    br, bg, bb = PAL["base"]
    return f"\x1b[1;48;2;{r};{g};{b}m\x1b[38;2;{br};{bg};{bb}m{s}\x1b[0m"


def vlen(s):
    return len(ANSI.sub("", s))


def trunc(s, n):
    return s if len(s) <= n else s[: max(n - 1, 0)] + "…"

def set_color(on):
    global COLOR
    COLOR = on


CW = 36


def card(title, rows, accent, width=CW):
    inner = width - 2
    dim = lambda s: fg("dim", s)
    lines = [dim("╭" + "─" * inner + "╮")]
    t = trunc(title, inner - 2)
    head = f" {t} "
    pad = inner - len(head)
    lines.append(dim("│") + badge(accent, head + " " * pad) + dim("│"))
    for left, right, kind in rows:
        if kind == "sep":
            body = " " * inner
        else:
            rlen = len(right)
            room = inner - 2 - (rlen + 3 if right else 0)
            l = trunc(left, room)
            lcol = fg({"on": "green", "off": "sub", "warn": "yellow", "bad": "red"}.get(kind, "text"), l)
            if right:
                dots = fg("dim", " " + "·" * max(inner - 2 - len(l) - rlen - 2, 1) + " ")
                body = " " + lcol + dots + fg(accent, right, True) + " "
            else:
                body = " " + lcol + " " * (inner - 1 - len(l))
        lines.append(dim("│") + body + dim("│"))
    lines.append(dim("╰" + "─" * inner + "╯"))
    return lines


def masonry(cards, cols_avail):
    ncols = max(1, (cols_avail - 2) // (CW + 2))
    cols = [[] for _ in range(ncols)]
    heights = [0] * ncols
    for c in cards:
        i = heights.index(min(heights))
        cols[i].append(c)
        heights[i] += len(c) + 1
    out = []
    n = max(heights) if heights else 0
    flat = []
    for col in cols:
        lines = []
        for c in col:
            lines += c + [""]
        lines += [""] * (n - len(lines))
        flat.append(lines)
    grid_w = ncols * (CW + 2) - 2
    left = max((cols_avail - grid_w) // 2, 0)
    for r in range(n):
        out.append(" " * left + "  ".join(f[r].ljust(0) + " " * (CW - vlen(f[r])) if vlen(f[r]) < CW else f[r] for f in flat).rstrip())
    return out


def rule(label, width, accent):
    txt = f" {label} "
    side = max((width - len(txt)) // 2, 2)
    return fg("dim", "─" * side) + fg(accent, txt, True) + fg("dim", "─" * side)



def pager(build_lines):
    import termios, tty
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    resized = [True]
    signal.signal(signal.SIGWINCH, lambda *_: resized.__setitem__(0, True))
    out = sys.stdout
    out.write("\x1b[?1049h\x1b[?25l")
    top, lines, redraw = 0, [], True
    try:
        tty.setcbreak(fd)
        while True:
            if resized[0]:
                cols, rows = shutil.get_terminal_size()
                lines = build_lines(cols)
                resized[0], redraw = False, True
            h = max(rows - 1, 1)
            top = max(0, min(top, max(len(lines) - h, 0)))
            if redraw:
                buf = ["\x1b[H"]
                for i in range(h):
                    buf.append((lines[top + i] if top + i < len(lines) else "") + "\x1b[K\n")
                pct = 100 if len(lines) <= h else int((top + h) * 100 / len(lines))
                foot = f" j/k ↑↓ scroll · space/b page · g/G top/end · q quit  ·  {pct}%"
                buf.append(fg("dim", foot[: cols - 1]) + "\x1b[K")
                out.write("".join(buf)); out.flush()
                redraw = False
            if not select.select([fd], [], [], 0.2)[0]:
                continue
            k = os.read(fd, 8).decode(errors="ignore")
            if k in ("q", "Q", "\x03") or k == "\x1b":
                break
            old_top = top
            if k in ("j", "\x1b[B", "\r", "\n"): top += 1
            elif k in ("k", "\x1b[A"): top -= 1
            elif k in (" ", "f", "\x1b[6~", "\x04"): top += h - 1
            elif k in ("b", "\x1b[5~", "\x15"): top -= h - 1
            elif k in ("g", "\x1b[H"): top = 0
            elif k in ("G", "\x1b[F"): top = len(lines)
            top = max(0, min(top, max(len(lines) - h, 0)))
            redraw = top != old_top
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)
        out.write("\x1b[?25h\x1b[?1049l"); out.flush()



def fzf(rows, prompt="  ❯ "):
    """Run fzf over ANSI rows; return the chosen row (ANSI stripped) or None."""
    if not shutil.which("fzf"):
        print("\n".join(ANSI.sub("", r) for r in rows)); return None
    r = subprocess.run(["fzf", "--ansi", "--layout=reverse", "--border=rounded", "--height=100%", "--margin=2,6",
                        f"--prompt={prompt}", "--no-sort", "--color=prompt:#cba6f7,pointer:#f5c2e7,border:#6c7086"],
                       input="\n".join(rows), text=True, stdout=subprocess.PIPE)
    return ANSI.sub("", r.stdout).rstrip("\n") or None
