# --- ENVIRONMENT VARIABLES --------------------------------------------------------------------------------------- #

# --- Core System
export EDITOR="nvim"
export BROWSER="dia"
export PAGER="bat"
export SHELL="zsh"
export TERM="xterm-256color"

# --- Language & Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# --- XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# --- Development Tools
export MISE_CONFIG_FILE="$XDG_CONFIG_HOME/mise/config.toml"
export NODE_OPTIONS="--max-old-space-size=4096"
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# --- ZSH Configuration
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# --- FZF Configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --preview="bat --style=numbers --color=always --line-range :500 {}"
  --preview-window=right:50%:wrap
  --bind="ctrl-u:preview-page-up,ctrl-d:preview-page-down"
  --bind="ctrl-f:preview-page-down,ctrl-b:preview-page-up"
'
export FZF_CTRL_R_OPTS="
  --preview='echo {}'
  --preview-window=down:3:hidden:wrap
  --bind='?:toggle-preview'
  --bind='ctrl-y:execute-silent(echo -n {} | pbcopy)'
"

# --- History Configuration
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="$XDG_STATE_HOME/zsh/history"

# --- Path Management
export PATH="$HOME/.local/bin:$PATH"
export PATH="$XDG_DATA_HOME/zinit/polaris/bin:$PATH"