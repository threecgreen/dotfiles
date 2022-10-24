# Bash aliases file
# Determine OS
case $(uname -s) in
    Linux*) OS="Linux";;
    Darwin*) OS="macOS";;
    Solaris*) OS="Solaris";;
    BSD*) OS="BSD";;
    CYGWIN*) OS="Cygwin";;
    MING*) OS="Ming";;
    *) echo "Unknown OS"
        OS="unknown";;
esac
export $OS

# enable color support of ls
if [ "$OS" = "macOS" ]; then
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
alias ll="ls -lFh"
alias la="ls -AlFh"
alias l="ls -1Fh"
alias lt="ls -ltFh"

# Make parent directories if they don"t exist and verbose output
alias mkdir="mkdir --parents --verbose"

# Alias nvim to vim and vi if installed
if [[ -f /usr/local/bin/nvim ]] || [[ -f /usr/bin/nvim ]]; then
    alias vi="nvim"
    alias vim="nvim"
fi

find-replace() {
    [ $1 ] || { echo "No search term specified" >&2; return 1 }
    [ $2 ] || { echo "No replace term specified" >&2; return 2 }
    rg -l $1 | xargs --delimiter '\n' sed --regexp-extended --in-place "s|$1|$2|g"
}

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
alias hx="helix"

# Add newline to EOF if it's missing from files in the given directory
add-nl-eol() {
    [ $1 ] || { echo "Missing directory" >&2; return 1; }
    git ls-files -z $1 | while IFS= read -rd '' f; do tail -c1 < "$f" | read -r _ || echo >> "$f"; done
}

