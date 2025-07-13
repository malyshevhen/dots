# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

alias c='clear'
alias v='$EDITOR'
alias vim='$EDITOR'
alias wifi='nmtui'

# -----------------------------------------------------
# GIT
# -----------------------------------------------------

alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------

alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# LIST FILES
# -----------------------------------------------------
alias lg='lazygit'
alias la='exa -al --color=always --group-directories-first --icons'
alias ll='exa --long --icons'
alias ls='exa --icons'
alias tree='exa --tree'
alias cd='z'

# -----------------------------------------------------
# WIFI
# -----------------------------------------------------

alias wifi-rescan='nmcli dev wifi list --rescan yes'

# -----------------------------------------------------
# TERMINAL
# -----------------------------------------------------

alias open='xdg-open'

# -----------------------------------------------------
# PODMAN
# -----------------------------------------------------

alias kube='podman kube'
alias pod='podman pod'
