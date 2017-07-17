# Bash aliases file
# Determine OS
case $(uname -s) in
    Linux*) OS="linux";;
    darwin*) OS="mac";;
    mysys*) OS="windows";;
    solaris*) OS="solaris";;
    bsd*) OS="bsd";;
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
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# some more ls aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# Make parent directories if they don"t exist and verbose output
alias mkdir="mkdir -pv"

# Alias nvim to vim and vi if installed
if [[ -f /usr/local/bin/nvim ]] || [[ -f /usr/bin/nvim ]]; then
    alias vi="nvim"
    alias vim="nvim"
fi
