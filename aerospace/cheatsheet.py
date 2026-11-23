#!/usr/bin/env python3
"""aes — AeroSpace cheatsheet (NvChad-style cards). Reads aerospace.toml live.

  aes              full-screen sheet (j/k scroll, q/esc quit)
  aes -s           fuzzy search every binding / app (fzf)
  aes keys|monitors|apps   show one section only
  aes --print      plain output (no pager)
"""
import json, os, re, shutil, subprocess, sys, tomllib
from pathlib import Path

sys.path.insert(0, str(Path.home() / ".config/cheatsheet"))
import ui
from ui import ACCENTS, CW, badge, card, fg, masonry, rule, trunc, vlen

CONF = Path(os.environ.get("AEROSPACE_CONFIG", Path.home() / ".config/aerospace/aerospace.toml"))
CACHE = Path.home() / ".cache/aerospace-cheatsheet.json"




# ─── parsing ────────────────────────────────────────────────────────────────────
MODS = {"ctrl": "⌃", "alt": "⌥", "shift": "⇧", "cmd": "⌘"}
KEYS = {"slash": "/", "comma": ",", "semicolon": ";", "minus": "-", "equal": "=", "tab": "⇥",
        "esc": "⎋", "enter": "⏎", "backspace": "⌫", "space": "␣", "period": ".",
        "left": "←", "right": "→", "up": "↑", "down": "↓"}
ARROW = {"left": "←", "down": "↓", "up": "↑", "right": "→"}
MODE_TITLE = {"main": "", "resize": "Resize", "service": "Service"}


def describe(cmd):
    if isinstance(cmd, list):
        cmd = [c for c in cmd if c != "mode main"] or ["mode main"]
        if len(cmd) == 2 and cmd[0].startswith("move-node-to-monitor") and cmd[1].startswith("focus-monitor"):
            return f"Send window to monitor {ARROW.get(cmd[0].split()[-1], '')}".strip()
        return describe(cmd[0]) if len(cmd) == 1 else " + ".join(describe(c) for c in cmd)
    t = cmd.split()
    c, last = t[0], t[-1]
    if c == "layout":
        if "floating" in t: return "Toggle floating"
        return f"Layout: {t[1]}"
    if c == "mode": return "Back to main" if last == "main" else f"Mode: {last}"
    if c == "workspace": return "Previous workspace" if last == "workspace-back-and-forth" else f"Go to workspace {last}"
    if c == "workspace-back-and-forth": return "Previous workspace"
    if c == "move-node-to-workspace": return f"Send window to workspace {last}"
    if c == "move-workspace-to-monitor": return "Workspace → next monitor"
    if c == "focus-monitor": return f"Focus monitor {ARROW.get(last, last)}"
    if c == "move-node-to-monitor": return f"Send window to monitor {ARROW.get(last, last)}"
    if c in ("focus", "move"): return f"{c.capitalize()} {ARROW.get(last, last)}"
    if c == "join-with": return f"Join {ARROW.get(last, last)}"
    if c == "resize":
        if t[1] == "smart": return "Shrink" if last.startswith("-") else "Grow"
        return f"{t[1].capitalize()} {'−' if last.startswith('-') else '+'}"
    return {"fullscreen": "Fullscreen", "flatten-workspace-tree": "Flatten tree",
            "balance-sizes": "Balance sizes", "reload-config": "Reload config",
            "close-all-windows-but-current": "Close all other windows"}.get(c, cmd)


def show_key(raw):
    parts = raw.split("-")
    mods = "".join(MODS[m] for m in ("ctrl", "alt", "shift", "cmd") if m in parts[:-1])
    key = KEYS.get(parts[-1], parts[-1])
    return f"{mods} {key}".strip()


def parse_bindings(text):
    """-> [(mode, group_title, [(mods, key, cmd)])] preserving file order, comments as titles."""
    groups, mode, title, cur = [], None, "", None
    for line in text.splitlines():
        s = line.strip()
        m = re.match(r"\[mode\.(\w+)\.binding\]", s)
        if m:
            mode, title, cur = m.group(1), "", None
            continue
        if s.startswith("["):
            mode = None
            continue
        if mode is None or not s:
            continue
        if s.startswith("#"):
            if "─" not in s:
                title, cur = s.lstrip("# ").strip(), None
            continue
        m = re.match(r"([\w-]+)\s*=\s*(.+)$", s)
        if not m:
            continue
        val = m.group(2)
        try:
            cmd = tomllib.loads(f"v = {val}")["v"]
        except Exception:
            try:
                cmd = tomllib.loads(f"v = {re.sub(r'\s+#.*$', '', val)}")["v"]
            except Exception:
                continue
        if cur is None:
            cur = []
            groups.append((mode, title, cur))
        parts = m.group(1).split("-")
        cur.append(("-".join(parts[:-1]), parts[-1], cmd))
    return groups


def compress(entries):
    """Collapse digit rows and hjkl quartets into single rows. -> [(keydisplay, desc)]"""
    out, used = [], set()
    def key_of(e): return e[0], e[1]
    # digits
    dig = {}
    for i, (mods, key, cmd) in enumerate(entries):
        if key.isdigit() and isinstance(cmd, str) and re.match(r"(workspace|move-node-to-workspace) \d$", cmd):
            dig.setdefault((mods, cmd.split()[0]), []).append(i)
    hj = {}
    for i, (mods, key, cmd) in enumerate(entries):
        if key in "hjkl" and len(key) == 1 and isinstance(cmd, str):
            m = re.match(r"(focus|move|join-with) (left|down|up|right)$", cmd)
            if m:
                hj.setdefault((mods, m.group(1)), []).append(i)
    collapsed = {}
    for (mods, verb), idx in dig.items():
        if len(idx) >= 3:
            ks = sorted((entries[i][1] for i in idx), key=lambda k: (k == "0", k))
            label = "Go to workspace N" if verb == "workspace" else "Send window to workspace N"
            collapsed[idx[0]] = (show_key(f"{mods}-{ks[0]}") + f"–{ks[-1]}" if mods else f"{ks[0]}–{ks[-1]}", label)
            used.update(idx)
    for (mods, verb), idx in hj.items():
        if len(idx) == 4:
            order = sorted(idx, key=lambda i: "hjkl".index(entries[i][1]))
            arrows = "".join(ARROW[entries[i][2].split()[-1]] for i in order)
            name = {"focus": "Focus", "move": "Move", "join-with": "Join"}[verb]
            collapsed[idx[0]] = (show_key(f"{mods}-h") + " j k l" if mods else "h j k l", f"{name} {arrows}")
            used.update(idx)
    for i, (mods, key, cmd) in enumerate(entries):
        if i in collapsed:
            out.append(collapsed[i])
        elif i not in used:
            out.append((show_key(f"{mods}-{key}" if mods else key), describe(cmd)))
    return out


def load():
    text = CONF.read_text()
    cfg = tomllib.loads(text)
    groups = parse_bindings(text)
    roles = {}
    for m in re.finditer(r"^#\s*Workspace\s+([\d /]+?)\s*→\s*(.+)$", text, re.M):
        for w in re.findall(r"\d", m.group(1)):
            roles[w] = m.group(2).strip()
    apps, floating = {}, []
    for rule in cfg.get("on-window-detected", []):
        app = rule.get("if", {}).get("app-id")
        run = rule.get("run")
        run = run if isinstance(run, list) else [run]
        for r in run:
            mm = re.match(r"move-node-to-workspace (\d)", r or "")
            if mm and app: apps.setdefault(mm.group(1), []).append(app)
            elif r == "layout floating" and app: floating.append(app)
    assign = {str(k): v if isinstance(v, list) else [v]
              for k, v in cfg.get("workspace-to-monitor-force-assignment", {}).items()}
    return groups, roles, apps, floating, assign


def sh(*args):
    try:
        r = subprocess.run(args, capture_output=True, text=True, timeout=3)
        return r.stdout.strip().splitlines() if r.returncode == 0 else None
    except Exception:
        return None


def app_names(ids):
    try: cache = json.loads(CACHE.read_text())
    except Exception: cache = {}
    dirty = False
    for i in ids:
        if i in cache: continue
        res = sh("mdfind", f"kMDItemCFBundleIdentifier == '{i}'")
        if res:
            cache[i] = Path(res[0]).name.removesuffix(".app")
            dirty = True
    if dirty:
        try:
            CACHE.parent.mkdir(parents=True, exist_ok=True)
            CACHE.write_text(json.dumps(cache))
        except Exception: pass
    return {i: cache.get(i, i.split(".")[-1]) for i in ids}


def live(assign):
    """-> (monitors{name:[ws]}, visible set, focused, running set, online)"""
    rows = sh("aerospace", "list-workspaces", "--monitor", "all", "--format", "%{workspace}|%{monitor-name}")
    mons = {}
    if rows:
        for r in rows:
            w, _, m = r.partition("|")
            mons.setdefault(m, []).append(w)
        vis = set(sh("aerospace", "list-workspaces", "--monitor", "all", "--visible") or [])
        foc = (sh("aerospace", "list-workspaces", "--focused") or [""])[0]
        running = {l.strip().lower() for l in (sh("aerospace", "list-windows", "--all", "--format", "%{app-name}") or [])}
        for m in mons: mons[m].sort(key=lambda w: (w == "0", w))
        return mons, vis, foc, running, True
    for w, pats in assign.items():
        mons.setdefault(pats[0], []).append(w)
    for m in mons: mons[m].sort(key=lambda w: (w == "0", w))
    return mons, set(), "", set(), False


# ─── cards & layout ─────────────────────────────────────────────────────────────
def build(data, width, sections):
    groups, roles, apps, floating, assign, names, (mons, vis, foc, running, online) = data
    out = []
    nws = len({w for ws in mons.values() for w in ws})
    title = "A E R O S P A C E   ·   C H E A T S H E E T"
    sub = f"{len(mons)} monitor{'s' if len(mons) != 1 else ''} · {nws} workspaces" + (f" · focused: {foc}" if foc else "") + ("" if online else " · aerospace offline")
    out += ["", " " * max((width - len(title)) // 2, 0) + fg("mauve", title, True),
            " " * max((width - len(sub)) // 2, 0) + fg("dim", sub), ""]

    if "keys" in sections:
        cards, i = [], 0
        for mode, gtitle, entries in groups:
            pre = MODE_TITLE.get(mode, mode.capitalize())
            t = gtitle or pre or "Main"
            if pre and gtitle and pre.lower() not in gtitle.lower(): t = f"{pre} · {gtitle}"
            rows = [(d, k, "") for k, d in compress(entries)]
            cards.append(card(t, rows, ACCENTS[i % len(ACCENTS)])); i += 1
        out += [rule("KEYBINDINGS", width, "blue"), ""] + masonry(cards, width) + [""]

    if "monitors" in sections:
        cards = []
        for i, (m, ws) in enumerate(sorted(mons.items(), key=lambda kv: (int(kv[1][0]) if kv[1][0] != "0" else 10))):
            rows = []
            for w in ws:
                mark = "●" if w == foc else ("○" if w in vis else " ")
                rows.append((f"{mark} {w}  {roles.get(w, '')}", f"{len(apps.get(w, []))} app{'s' if len(apps.get(w, [])) != 1 else ''}", "on" if w == foc else ""))
            cards.append(card(m, rows, ACCENTS[(i + 2) % len(ACCENTS)]))
        out += [rule("MONITORS", width, "green"), ""] + masonry(cards, width) + [""]

    if "apps" in sections:
        cards, i = [], 0
        for w in sorted(apps, key=lambda w: (w == "0", w)):
            rows = []
            for a in apps[w]:
                n = names[a]
                rows.append((("● " if n.lower() in running else "  ") + n, "", "on" if n.lower() in running else ""))
            cards.append(card(f"{w} · {roles.get(w, 'Workspace')}", rows, ACCENTS[i % len(ACCENTS)])); i += 1
        if floating:
            cards.append(card("Floating", [(("● " if names[a].lower() in running else "  ") + names[a], "", "on" if names[a].lower() in running else "") for a in floating], "red"))
        out += [rule("APPS  (● running)", width, "peach"), ""] + masonry(cards, width) + [""]
    return out


# ─── pager ──────────────────────────────────────────────────────────────────────
def search(data):
    groups, roles, apps, floating, assign, names, (mons, *_rest) = data
    rows = []
    for mode, gtitle, entries in groups:
        label = (MODE_TITLE.get(mode) or "Main")
        for mods, key, cmd in entries:
            rows.append(f"{fg('mauve', show_key(f'{mods}-{key}' if mods else key).ljust(14))} {describe(cmd).ljust(34)} {fg('dim', label + (' · ' + gtitle if gtitle else ''))}")
    for w, ids in apps.items():
        for a in ids:
            rows.append(f"{fg('green', ('workspace ' + w).ljust(14))} {names[a].ljust(34)} {fg('dim', 'app · ' + roles.get(w, ''))}")
    for a in floating:
        rows.append(f"{fg('red', 'floating'.ljust(14))} {names[a].ljust(34)} {fg('dim', 'app')}")
    ui.fzf(rows, "  aerospace ❯ ")


def main():
    args = sys.argv[1:]
    if any(a in ("-h", "--help") for a in args):
        print(__doc__); return
    sections = [a for a in args if a in ("keys", "monitors", "apps")] or ["keys", "monitors", "apps"]
    data_cfg = load()
    groups, roles, apps, floating, assign = data_cfg
    ids = {a for v in apps.values() for a in v} | set(floating)
    data = (*data_cfg, app_names(ids), live(assign))
    if "-s" in args or "--search" in args:
        ui.set_color(True)
        search(data); return
    if "--print" in args or not sys.stdout.isatty():
        ui.set_color(sys.stdout.isatty() and "NO_COLOR" not in os.environ)
        cols = shutil.get_terminal_size().columns if sys.stdout.isatty() else int(os.environ.get("COLUMNS", 100))
        print("\n".join(build(data, cols, sections)))
        return
    ui.set_color("NO_COLOR" not in os.environ)
    ui.pager(lambda cols: build(data, cols, sections))


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
