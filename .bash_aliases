# Bash aliases file
# Determine OS
case $(uname -s) in
    Linux*) OS="linux";;
    Darwin*) OS="mac";;
    Solaris*) OS="solaris";;
    BSD*) OS="bsd";;
    CYGWIN*) OS="cygwin";;
    *) echo "Unknown OS"
        exit 1;;
esac

# enable color support of ls
if [ "$OS" = "mac" ]; then
    # Mac specific ls alias
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

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
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias lt="ls -lt"

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

# Xclip copy/paste
alias cbcopy="xclip -selection c"
alias cbpaste="xclip -o"

