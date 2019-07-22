alias ls='ls --color=auto'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

# Case insensitive grep by default
alias grep='grep -i --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

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
alias lat="ls -AltFh"

# Make parent directories if they don"t exist and verbose output
alias mkdir="mkdir -pv"

# Alias nvim to vim and vi if installed
if [[ -f /usr/local/bin/nvim ]] || [[ -f /usr/bin/nvim ]]; then
    alias vi="nvim"
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
# Zsh displays env already
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Xclip copy/paste
alias cbcopy="xclip -selection c"
alias cbpaste="xclip -o"

# Virtualenvwrapper
export WORKON_HOME="$HOME/.envs"
export PROJECT_HOME="$HOME/nfs-git"
. /usr/bin/virtualenvwrapper.sh

# Scripts
export PATH="$PATH:$HOME/bin"

# Fake hydra via remote execution
hydra() {
    ssh chivmdev207 "cd /home/cgreen/git/Harbor; hydra $@;"
}

