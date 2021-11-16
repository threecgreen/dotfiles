alias ls='ls --color=auto'

# Easier navigation upward with cd
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# some more ls aliases
alias ll="ls -lFh"
alias la="ls -AlFh"
alias l="ls -1Fh"
alias lt="ls -ltFh"

# Make parent directories if they don"t exist and verbose output
alias mkdir="mkdir -pv"

# Alias nvim to vim and vi if installed
if [[ -f /usr/local/bin/nvim ]] || [[ -f /usr/bin/nvim ]]; then
    alias vim="nvim"
fi

# Use bat instead of cat if installed
if [ -f /usr/bin/ccat ]; then
    alias cat="ccat"
fi

# Use prettyping instead of ping
if [ -f /usr/bin/prettyping ]; then
    alias ping="prettyping --nolegend"
fi

# i3 Default terminal
if [ -f /usr/bin/alacritty ]; then
    export TERMINAL=alacritty
fi

