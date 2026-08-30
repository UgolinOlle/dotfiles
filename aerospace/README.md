# AeroSpace Config

Tiling window manager setup organized around a coding workflow. Numbered
workspaces 1–6 live on the primary monitor, 7/8/9/0 are force-assigned to the
secondary monitor.

## Workspace Layout

| # | Purpose            | Apps                                                  | Monitor   |
|---|---------------------|--------------------------------------------------------|-----------|
| 1 | Browser             | Dia                                                     | Primary   |
| 2 | Code Editor         | VSCode Insiders                                         | Primary   |
| 3 | Terminal / Dev Tools| Ghostty, Zellij, UTM, Chrome for Testing                | Primary   |
| 4 | DB & API            | TablePlus, Claude Desktop                               | Primary   |
| 5 | Documentation       | Notion                                                  | Primary   |
| 6 | Design              | Figma                                                   | Primary   |
| 7 | Calendar & Email    | Calendar, Mail                                          | Secondary |
| 8 | Communication       | Beeper                                                  | Secondary |
| 9 | Communication       | Discord                                                 | Secondary |
| 0 | System Utilities    | Activity Monitor, NordVPN, CleanMyMac, Spotify          | Secondary |

Windows are routed automatically via `on-window-detected` rules — no manual
sorting needed. Finder, FaceTime, Messages, and Screen Studio always open
floating instead of tiling.

## Keybindings — Main Mode

### Focus & movement
| Key            | Action              |
|----------------|---------------------|
| `alt-h/j/k/l`  | Focus left/down/up/right |
| `alt-shift-h/j/k/l` | Move window left/down/up/right |
| `cmd-alt-h/j/k/l`   | Join window into container left/down/up/right |

### Layout
| Key              | Action                        |
|------------------|--------------------------------|
| `alt-slash`      | Tiles layout                  |
| `alt-comma`      | Accordion layout               |
| `alt-shift-f`    | Fullscreen toggle              |
| `alt-shift-r`    | Reset layout (flatten tree)    |
| `alt-shift-0`    | Balance window sizes           |
| `alt-shift-minus`/`alt-shift-equal` | Shrink/grow window |

### Workspaces
| Key            | Action                                  |
|----------------|------------------------------------------|
| `alt-1`…`alt-0`| Switch to workspace 1–9, 0               |
| `alt-tab`      | Back-and-forth to last workspace         |
| `alt-shift-tab`| Move current workspace to next monitor   |
| `ctrl-shift-tab`| Move current window to next monitor     |
| `cmd-shift-1`…`cmd-shift-0` | Send window to workspace 1–9, 0 (stay put) |
| `cmd-alt-shift-2`/`3` | Send window to editor/terminal and follow it |

### Mode
| Key                  | Action              |
|----------------------|---------------------|
| `alt-shift-semicolon`| Enter service mode  |

## Keybindings — Service Mode

Entered with `alt-shift-semicolon`, exited automatically after each action
(or with `esc`).

| Key         | Action                                  |
|-------------|-------------------------------------------|
| `esc`       | Reload config, back to main mode          |
| `f`         | Toggle floating/tiling on current window  |
| `backspace` | Close all windows except the focused one  |

## Notes

- `move-mouse` events keep the cursor centered on the focused window/monitor,
  so you never lose track of it after a workspace or monitor switch.
- Gaps: 10px inner and outer on all sides.
