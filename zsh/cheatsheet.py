#!/usr/bin/env python3
"""zs — zsh cheatsheet (NvChad-style cards). Parses your zsh config live.

  zs                    full-screen sheet (j/k scroll, q/esc quit)
  zs -s                 fuzzy search aliases / functions / keys (Enter copies)
  zs keys|aliases|functions|plugins|options|env|health   one section only
  zs --print            plain output (no pager)
"""
import os, re, shlex, shutil, subprocess, sys
from pathlib import Path

sys.path.insert(0, str(Path.home() / ".config/cheatsheet"))
import ui
from ui import ACCENTS, ANSI, card, fg, masonry, rule, trunc

HOME = Path.home()
ZSHRC = HOME / ".zshrc"
RC = ZSHRC.resolve() if ZSHRC.exists() else HOME / ".config/.zsrhc"
ENV = HOME / ".config/zsh/env.zsh"
PLUGINS = HOME / ".config/zsh/plugins.zsh"
SECRET = re.compile(r"KEY|TOKEN|SECRET|PASS|AUTH|CRED|PRIVATE", re.I)
SECTIONS = ["keys", "aliases", "functions", "plugins", "options", "env", "health"]


def read(p):
    try:
        return p.read_text().splitlines()
    except OSError:
        return []


# ─── parsing ────────────────────────────────────────────────────────────────────
MAJOR = re.compile(r"^# --- ([A-Z][A-Z &/]+?)\s+-{8,}")
MINOR = re.compile(r"^# --- (.+?)\s*$")


def unquote(v):
    try:
        parts = shlex.split(v)
        return (parts[0] if parts else "").replace("\\$", "$")
    except ValueError:
        return v.strip("'\"")


def parse_rc(lines):
    aliases, funcs, options = [], [], []   # aliases: (group, name, expansion, lineno)
    major = minor = optgroup = ""
    facts = dict(fpath_lines=[], source_plugins=0, bindkey=False)
    for i, line in enumerate(lines):
        m = MAJOR.match(line)
        if m:
            major, minor = m.group(1).title(), ""
            continue
        m = MINOR.match(line)
        if m and line.startswith("# ---"):
            minor = m.group(1)
            continue
        m = re.match(r"#\s+(\w[\w ]*?) options\s*$", line)
        if m:
            optgroup = m.group(1)
            continue
        m = re.match(r"alias\s+([^=\s]+)=(.*)$", line)
        if m:
            group = minor if major == "Aliases" and minor else (major or "Misc")
            if major != "Aliases" and "CLAUDE HELPER" in major.upper(): group = "Claude helpers"
            aliases.append((group, m.group(1), unquote(m.group(2)), i + 1))
            continue
        m = re.match(r"(?:function\s+(\w+)\s*\(\)|(\w+)\(\))\s*\{", line)
        if m:
            name, usage = m.group(1) or m.group(2), ""
            for body in lines[i + 1:i + 12]:
                if body.startswith("}"): break
                u = re.search(r"Usage:\s*(.+?)[\"']", body)
                if u: usage = u.group(1); break
            funcs.append((minor, name, usage))
            continue
        m = re.match(r"setopt\s+(\w+)", line)
        if m:
            options.append((optgroup or "General", m.group(1)))
        if re.match(r"\s*fpath=", line): facts["fpath_lines"].append(i + 1)
        if re.search(r"source\s+\S*plugins\.zsh", line): facts["source_plugins"] = i + 1
        if "bindkey" in line: facts["bindkey"] = True
    return aliases, funcs, options, facts


def parse_plugins(lines):
    out, group, in_block = [], "Plugins", False
    for line in lines:
        s = line.strip()
        m = re.match(r"#\s*---\s*(.+?)\s*$", s)
        if m and not s.startswith("# zinit"):
            group = m.group(1)
            continue
        if s.startswith("#") or not s:
            if not s: in_block = False
            continue
        if s.startswith("zinit"): in_block = True
        m = re.match(r"(?:light-mode\s+)?([\w.-]+(?:::[\w./-]+|/[\w./-]+))\s*\\?$", s)
        if in_block and m:
            src = m.group(1)
            out.append((group, src.split("::")[-1].split("/")[-1], "omz" if "::" in src else "gh", src))
    return out


def parse_env(lines):
    """-> ([(group, name, value|None)], fzf_binds[(var, key, action)])"""
    env, binds, group, i = [], [], "Environment", 0
    path_n = 0
    while i < len(lines):
        line = lines[i]
        m = MAJOR.match(line)
        if m:
            i += 1; continue
        m = MINOR.match(line)
        if m and line.startswith("# ---"):
            group = m.group(1); i += 1; continue
        m = re.match(r"export\s+(\w+)=(.*)$", line)
        if not m:
            i += 1; continue
        name, val = m.group(1), m.group(2)
        block = val
        while block.count("'") % 2 or block.count('"') % 2:
            i += 1
            if i >= len(lines): break
            block += "\n" + lines[i]
        multi = "\n" in block
        for b in re.findall(r"--bind=([^\s'\"]+)", block):
            k, _, a = b.partition(":")
            binds.append((name, k, a))
        shown = None if SECRET.search(name) else block.strip("'\"")
        if name == "PATH":
            path_n += 1
            if path_n == 1: env.append((group, name, "PATH"))
        else:
            env.append((group, name, "multi-line" if multi else shown))
        i += 1
    if path_n:
        env = [(g, n, f"{path_n} entries" if n == "PATH" else v) for g, n, v in env]
    return env, binds


def shell_words():
    try:
        r = subprocess.run(["zsh", "-fc", "print -l ${(k)builtins} ${(k)reswords}"], capture_output=True, text=True, timeout=3)
        return set(r.stdout.split())
    except Exception:
        return set()


# ─── health (computed, so it stays correct after fixes) ─────────────────────────
def health(aliases, funcs, plugins, facts, rc_lines):
    known = {a[1] for a in aliases} | {f[1] for f in funcs} | shell_words()
    shadows, broken, notes = [], [], []
    seen = {}
    for g, name, exp, ln in aliases:
        if name in seen: notes.append((f"{name} defined twice", "dup"))
        seen[name] = ln
        path = shutil.which(name)
        if path and not name.startswith(("clean:", "ch")) and path != exp:
            shadows.append((f"{name} › {path}", "shadow"))
        for seg in re.split(r"&&|\|\||[;|]|\$\(", exp):
            try: words = shlex.split(seg)
            except ValueError: words = seg.split()
            while words and (re.match(r"\w+=", words[0]) or words[0] in ("sudo", "command", "builtin", "exec")):
                words.pop(0)
            if not words: continue
            w = words[0]
            if w in known or shutil.which(w) or (("/" in w) and os.access(os.path.expanduser(w), os.X_OK)): continue
            if w.startswith(("{", "$", "-", "(")) or w in ("do", "done", "then", "fi", "i"): continue
            broken.append((f"{name} › {w}", "missing"))
        if re.search(r"(?:^|[\s;&|])(?<!command )rm\s+-\w*r", exp) and seen.get("rm", "") and next((a[2] for a in aliases if a[1] == "rm"), "") == "trash":
            broken.append((f"{name} › rm → trash", "flags"))
    pl = max([facts["source_plugins"]] or [0])
    for ln in facts["fpath_lines"]:
        if pl and ln > pl:
            notes.append((f"fpath set at L{ln}, after compinit", "order"))
    if any(p[1] == "zsh-history-substring-search" for p in plugins) and not facts["bindkey"]:
        notes.append(("history-substring-search: no bindkey", "unbound"))
    return shadows, broken, notes


# ─── key catalogue (derived from what is installed/loaded) ──────────────────────
def key_rows(plugins, binds):
    names = {p[1] for p in plugins}
    rows = []
    if (HOME / ".fzf.zsh").exists() or shutil.which("fzf"):
        rows += [("fzf · file picker", "⌃ T"), ("fzf · history search", "⌃ R"), ("fzf · cd into directory", "⌥ C")]
    if "fzf-tab" in names: rows.append(("fzf-tab · complete", "⇥"))
    if "zsh-autosuggestions" in names: rows.append(("Accept suggestion", "→"))
    return rows


def nice_key(k):
    return re.sub(r"ctrl-", "⌃ ", re.sub(r"alt-", "⌥ ", k)).replace("shift-", "⇧ ").replace("-", " ")


# ─── build ──────────────────────────────────────────────────────────────────────
def load():
    rc = read(RC)
    aliases, funcs, options, facts = parse_rc(rc)
    plugins = parse_plugins(read(PLUGINS))
    env, binds = parse_env(read(ENV))
    return dict(aliases=aliases, funcs=funcs, options=options, facts=facts, plugins=plugins, env=env,
                binds=binds, health=health(aliases, funcs, plugins, facts, rc))


def group(items, key):
    out = {}
    for it in items:
        out.setdefault(key(it), []).append(it)
    return out


def build(d, width, sections):
    out = []
    title = "Z S H   ·   C H E A T S H E E T"
    sub = f"{len(d['aliases'])} aliases · {len(d['funcs'])} functions · {len(d['plugins'])} plugins · {RC.name}"
    out += ["", " " * max((width - len(title)) // 2, 0) + fg("mauve", title, True),
            " " * max((width - len(sub)) // 2, 0) + fg("dim", sub), ""]
    palette = lambda i: ACCENTS[i % len(ACCENTS)]

    def block(label, color, cards):
        if cards:
            out.extend([rule(label, width, color), ""] + masonry(cards, width) + [""])

    if "keys" in sections:
        cards = []
        rows = key_rows(d["plugins"], d["binds"])
        if rows: cards.append(card("Shell keys", [(a, b, "") for a, b in rows], "blue"))
        seen = set()
        brow = []
        for var, k, a in d["binds"]:
            if (k, a) not in seen:
                seen.add((k, a)); brow.append((a, nice_key(k), ""))
        if brow: cards.append(card("fzf binds", brow, "mauve"))
        block("KEYS", "blue", cards)

    if "aliases" in sections:
        cards = [card(g, [(e, n, "") for _, n, e, _ in items], palette(i))
                 for i, (g, items) in enumerate(group(d["aliases"], lambda a: a[0]).items())]
        block("ALIASES", "green", cards)

    if "functions" in sections and d["funcs"]:
        rows = []
        for g, name, usage in d["funcs"]:
            rows.append((g or name, name, ""))
            if usage:
                rows.append(("  ↳ " + re.sub(r"^\S+", name, usage), "", "off"))
        block("FUNCTIONS", "peach", [card("Functions", rows, "peach")])

    if "plugins" in sections:
        cards = [card(g, [(n, t, "") for _, n, t, _ in items], palette(i + 3))
                 for i, (g, items) in enumerate(group(d["plugins"], lambda p: p[0]).items())]
        block("PLUGINS  (zinit)", "teal", cards)

    if "options" in sections:
        cards = [card(f"{g} options", [(n.lower(), "on", "") for _, n in items], palette(i + 1))
                 for i, (g, items) in enumerate(group(d["options"], lambda o: o[0]).items())]
        block("SETOPT", "pink", cards)

    if "env" in sections:
        cards = []
        for i, (g, items) in enumerate(group(d["env"], lambda e: e[0]).items()):
            rows = [(n, "••••" if v is None else trunc(v, 14), "") for _, n, v in items]
            cards.append(card(g, rows, palette(i + 2)))
        block("ENVIRONMENT  (secrets masked)", "yellow", cards)

    if "health" in sections:
        shadows, broken, notes = d["health"]
        cards = []
        if broken: cards.append(card("Broken", [(l, r, "bad") for l, r in broken], "red"))
        if notes: cards.append(card("Order / setup", [(l, r, "warn") for l, r in notes], "yellow"))
        if shadows: cards.append(card("Shadowed commands", [(l, r, "warn") for l, r in shadows], "peach"))
        if not cards: cards.append(card("Health", [("all clear ✓", "", "on")], "green"))
        block("HEALTH", "red", cards)
    return out


def copy(text):
    try:
        subprocess.run(["pbcopy"], input=text, text=True, timeout=2)
        return True
    except Exception:
        return False


def search(d):
    rows, payload = [], {}
    for g, n, e, _ in d["aliases"]:
        r = f"{fg('green', n.ljust(14))} {trunc(e, 60).ljust(60)} {fg('dim', 'alias · ' + g)}"
        rows.append(r); payload[ui.ANSI.sub('', r)] = e
    for g, n, usage in d["funcs"]:
        r = f"{fg('peach', n.ljust(14))} {trunc(usage or g, 60).ljust(60)} {fg('dim', 'function')}"
        rows.append(r); payload[ui.ANSI.sub('', r)] = n
    for a, b in key_rows(d["plugins"], d["binds"]):
        rows.append(f"{fg('blue', b.ljust(14))} {a.ljust(60)} {fg('dim', 'key')}")
    pick = ui.fzf(rows, "  zsh ❯ ")
    if pick and pick in payload and copy(payload[pick]):
        print(f"copied: {payload[pick]}", file=sys.stderr)


def main():
    args = sys.argv[1:]
    if any(a in ("-h", "--help") for a in args):
        print(__doc__); return
    sections = [a for a in args if a in SECTIONS] or SECTIONS
    d = load()
    if "-s" in args or "--search" in args:
        ui.set_color(True); search(d); return
    if "--print" in args or not sys.stdout.isatty():
        ui.set_color(sys.stdout.isatty() and "NO_COLOR" not in os.environ)
        cols = shutil.get_terminal_size().columns if sys.stdout.isatty() else int(os.environ.get("COLUMNS", 100))
        print("\n".join(build(d, cols, sections))); return
    ui.set_color("NO_COLOR" not in os.environ)
    ui.pager(lambda cols: build(d, cols, sections))


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
