ulimit -n 4096

export FPATH=$HOME/.rbenv/completions:"$FPATH"
export FPATH=$HOME/.local/share/zsh/asdf/completions:$FPATH

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.rubies/ruby-3.3.4/bin:$PATH
export PATH=$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

export OPENCV_LOG_LEVEL=ERROR

export JAVA_HOME=/home/evhen/.sdkman/candidates/java/current

# Kaa creds
export ARTIFACTORY_USERNAME=$(secret-tool lookup key kaa_username)
export ARTIFACTORY_PASSWORD=$(secret-tool lookup key kaa_password)
export GITLAB_TOKEN=$(secret-tool lookup key gitlab_token)
export GITLAB_USER=$(secret-tool lookup key gitlab_user)
export GITLAB_PASSWORD=$(secret-tool lookup key gitlab_password)
export GITLAB_VIM_URL='https://gitlab.kaaiot.net'

# AI API secrets
export CODY_TOKEN=$(secret-tool lookup key cody_token)
export GEMINI_API_KEY=$(secret-tool lookup key gemini_api_key)
export GOOGLE_AI_API_KEY=$GEMINI_API_KEY

# Neovim Logging
export NVIM_LOG_FILE=$HOME/.local/state/nvim/log

# -----------------------------------------------------
# ZINIT SETTINGS
# -----------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

## Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit load zsh-users/zsh-history-substring-search
zinit ice wait atload'_history_substring_search_config'

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_dups

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zstyle ':comletion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':comletion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':comletion:*' menu no
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

autoload -U compinit && compinit

zinit cdreplay -q

# Golang
# export GOROOT=$HOME/.local/go
# export GOPATH=$HOME/go
# export GOBIN=$HOME/.local/bin
# export PATH=$GOROOT/bin:$PATH
# export PATH=$GOPATH/bin:$PATH
# export PATH=$GOBIN:$PATH
export PATH=/usr/lib/w3m:$PATH
export GOPRIVATE=gitlab.kaaiot.net

# Python
export PYTHONPATH=/usr/lib/python3.12/site-packages:$PYTHONPATH

# ZVM
export PATH=$HOME/.zvm/bin:$PATH

# Odin
export PATH=$HOME/odin/bin:$PATH

export PATH="/usr/lib/ccache/bin/:$PATH"

# Config home
export XDG_CONFIG_HOME=$HOME/.config

#### ------------------------------
#### exa - Color Scheme Definitions
#### ------------------------------
export EXA_COLORS="\
uu=36:\
gu=37:\
sn=32:\
sb=32:\
da=34:\
ur=34:\
uw=35:\
ux=36:\
ue=36:\
gr=34:\
gw=35:\
gx=36:\
tr=34:\
tw=35:\
tx=36:"

# -----------------------------------------------------
# SESH KEYBIND
# -----------------------------------------------------
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# -----------------------------------------------------
# NEOVIM SWITCH
# -----------------------------------------------------
alias lvim="NVIM_APPNAME=LazyVim nvim"
# alias nvim-kick="NVIM_APPNAME=kickstart nvim"
alias nvim-chad="NVIM_APPNAME=NvChad nvim"
# alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

function nvims() {
  items=("default" "NvChad")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# -----------------------------------------------------
# Aliases
# -----------------------------------------------------
source $HOME/.config/zsh/aliases.zsh

# -----------------------------------------------------
# START STARSHIP
# -----------------------------------------------------
# eval "$(starship init zsh)"

# -----------------------------------------------------
# START THEFUCK
# -----------------------------------------------------
eval $(thefuck --alias fuck)

# -----------------------------------------------------
# START ZOXIE
# -----------------------------------------------------
eval "$(zoxide init zsh)"

# -----------------------------------------------------
# PYWAL
# -----------------------------------------------------
# cat ~/.cache/wal/sequences

# -----------------------------------------------------
# Fzf init
# -----------------------------------------------------
eval "$(fzf --zsh)"

# Added by `rbenv init` on Sun Aug 25 04:55:49 PM EEST 2024
eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"

# -----------------------------------------------------
# Pipx init
# -----------------------------------------------------
eval "$(register-python-argcomplete pipx)"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/evhen/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/evhen/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/evhen/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/evhen/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# OH-MY-POSH
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
