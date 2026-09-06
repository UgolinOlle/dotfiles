# Zsh Cheatsheet

Aliases and functions defined in `~/.zshrc`. View this anytime with `rme`.

## Aliases

### Misc

| Alias | Command | Description |
|---|---|---|
| `cls` | `clear` | Clear the terminal |
| `sz` | `source ~/.zshrc && mise doctor` | Reload shell config and check mise health |
| `rm` | `trash` | Move files to trash instead of deleting |
| `grep` | `grep --color=auto` | Colorized grep |
| `cat` | `bat` | `cat` with syntax highlighting |
| `x` | `exit` | Exit the shell |

### Tools

| Alias | Command | Description |
|---|---|---|
| `nm` | `nmap -sC -sV -oN nmap` | Nmap scan with default scripts + version detection, saved to file `nmap` |
| `ports` | `lsof -i -P -n \| grep LISTEN` | List listening ports |

### Clean

| Alias | Command | Description |
|---|---|---|
| `clean:node` | `rm -rf node_modules package-lock.json && npm install` | Wipe and reinstall Node deps |
| `clean:laravel` | `php artisan cache:clear && ... view:clear` | Clear all Laravel caches |
| `clean:docker` | `docker system prune -af --volumes` | Remove all unused Docker data, images, and volumes |

### Paths

| Alias | Command | Description |
|---|---|---|
| `dv` | `cd ~/Developer` | Jump to Developer folder |
| `dd` | `cd ~/Documents` | Jump to Documents folder |
| `dw` | `cd ~/Downloads` | Jump to Downloads folder |
| `wh` | `cd ~/Developer/whoa-projects/` | Jump to whoa-projects folder |
| `conf` | `cd ~/.config` | Jump to config folder |
| `h` | `cd ~` | Jump to home |
| `..` | `cd ..` | Go up one directory |
| `f` | fzf file picker → open in `nvim` | Fuzzy-find a file and open it |
| `fd` | fzf file picker → `cd` to its directory | Fuzzy-find a file and `cd` there |

### List

| Alias | Command | Description |
|---|---|---|
| `lr` | `eza --tree --level=2 --long --icons --git` | Tree view, 2 levels deep |
| `lra` | `lt -a` | Tree view including hidden files |
| `ll` | `eza --color=always --long --git --header --icons` | Long listing with git status |
| `ls` | `eza --color=always --long --git --no-filesize --icons --no-user --no-permissions --no-time` | Compact long listing |

### Brew

| Alias | Command | Description |
|---|---|---|
| `bu` | `brew upgrade` | Upgrade all formulae |
| `bi` | `brew install` | Install a formula |
| `bic` | `brew install --cask` | Install a cask |
| `br` | `brew uninstall` | Uninstall a formula |
| `bp` | outdated → update → upgrade → autoremove → cleanup | Full Homebrew maintenance sweep |
| `bs` | `brew services` | Manage background services |

### PostgreSQL

| Alias | Command | Description |
|---|---|---|
| `pgstart` | `brew services start postgresql@18` | Start PostgreSQL |
| `pgstop` | `brew services stop postgresql@18` | Stop PostgreSQL |
| `pgcli` | `psql postgres` | Open psql on the `postgres` database |

### Docker

| Alias | Command | Description |
|---|---|---|
| `d` | `docker` | Shorthand |
| `ld` | `lazydocker` | Open lazydocker TUI |
| `da` | `docker start` | Start a container |
| `dx` | `docker exec -it` | Exec into a container |
| `dc` | `docker compose` | Shorthand |
| `dr` | `docker restart` | Restart a container |
| `dl` | `docker logs` | Show container logs |
| `df` | `docker ps --format ...` | List containers (ID, name, status, ports) |
| `drs` | `docker compose down && docker compose up` | Full stack restart |

### Git

| Alias | Command | Description |
|---|---|---|
| `g` | `git` | Shorthand |
| `lg` | `lazygit` | Open lazygit TUI |
| `ga` | `git add .` | Stage everything |
| `gcm` | `git commit -m` | Commit with message |
| `gco` | `git checkout` | Checkout a branch |
| `gcb` | `git checkout -b` | Create and checkout a branch |
| `glg` | `git log --oneline --graph --decorate` | Compact graph log |
| `gfix` | `git commit --amend --no-edit` | Amend last commit without changing message |

### Neovim

| Alias | Command | Description |
|---|---|---|
| `n` / `nv` | `nvim` | Shorthand |
| `vim` / `vi` | `nvim` | Redirect to nvim |
| `nz` | `nv ~/.zshrc` | Edit `.zshrc` |
| `ns` | `sudo nvim` | Edit as root |
| `nenv` | `nv .env` | Edit local `.env` |

### NPM

| Alias | Command | Description |
|---|---|---|
| `ni` | `npm install` | Install deps |
| `nu` | `npm uninstall` | Uninstall a package |
| `nl` | `npm list` | List installed packages |
| `nr` | `npm run` | Run a script |
| `nc` | `rm -rf node_modules && npm cache clean --force` | Nuke node_modules and npm cache |
| `dev` | `npm run dev` | Run the dev script |

### Health & Maintenance

| Alias | Command | Description |
|---|---|---|
| `zshtime` | `time zsh -i -c exit` | Measure shell startup time (single run) |
| `zshbench` | loops `zshtime` 10x | Measure shell startup time (10 runs) |

### Docs

| Alias | Command | Description |
|---|---|---|
| `rme` | `glow ~/.config/zsh/README.md` | Show this cheatsheet |

### Claude Helpers

| Alias | Command | Description |
|---|---|---|
| `chinit` | `cp ~/.claude/CLAUDE_PROJECT.md ./CLAUDE.md` | Seed a project with the Claude template |
| `ch` | `claude-helper.sh` | Main Claude helper entrypoint |
| `chp` | `project-info.sh` | Project overview |
| `chs` | `search-tools.sh` | Code search helpers |

## Functions

### `cdf`
Fuzzy-find a directory under `~` and `cd` into it.
```
cdf
```

### `fproc <keyword>`
Find running processes matching a keyword (excludes the grep call itself).
```
fproc node
```

### `ckurl <url>`
Print the HTTP status line for a URL.
```
ckurl https://example.com
```

### `compress <source> <destination>`
Tar + gzip a folder or file into `<destination>.tar.gz`.
```
compress my-folder backup
```

### `decompress <archive>`
Extract a `.tar.gz` archive.
```
decompress backup.tar.gz
```

### `kport <port>`
Kill whatever process is listening on a given port.
```
kport 3000
```

### `rpw <length>`
Generate a random password of a given length.
```
rpw 16
```

### `sha256check <checksum> <file>`
Verify a file against a known sha256 checksum (does **not** generate a hash — it checks one).
```
sha256check e3b0c4... myfile.txt
```
