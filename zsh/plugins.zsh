# --- ZINIT PLUGIN CONFIGURATION ---------------------------------------------------------------------------------- #

# --- Core Zinit Setup
zinit wait lucid for \
  OMZL::git.zsh \
  OMZL::key-bindings.zsh \
  OMZL::theme-and-appearance.zsh

# --- Essential Plugins
zinit wait lucid for \
  light-mode  zsh-users/zsh-autosuggestions \
  light-mode  zsh-users/zsh-completions \
  light-mode  zdharma-continuum/fast-syntax-highlighting

# --- Interactive Plugins
zinit wait lucid for \
  light-mode  Aloxaf/fzf-tab

# --- OMZ Plugins
zinit wait lucid for \
  OMZP::git \
  OMZP::brew \
  OMZP::colored-man-pages \
  OMZP::colorize

# --- Advanced Tools
zinit wait"1" lucid for \
  light-mode  zsh-users/zsh-history-substring-search

# --- Completions
# zinit wait lucid as"completion" for \
#   OMZP::docker/_docker \
#   OMZP::docker-compose/_docker-compose

# --- Load custom completions
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# --- Completion Styling
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'