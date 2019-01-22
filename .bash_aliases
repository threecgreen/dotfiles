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

# Xclip copy/paste
alias cbcopy="xclip -selection c"
alias cbpaste="xclip -o"

# Zsh displays env already
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Virtualenvwrapper
export WORKON_HOME="$HOME/.envs"
export PROJECT_HOME="$HOME/nfs-git"
source /usr/bin/virtualenvwrapper.sh

# Scripts
export PATH="$PATH:$HOME/bin"

# Conda
. /opt/anaconda/etc/profile.d/conda.sh

# Local variables
buildDir="$HOME/build"
harborBase="$HOME/nfs-git/Harbor"
pythonDir="$harborBase/Python"
srcDir="$harborBase/Laser"
clangTidyDir="$srcDir/ContinuousDelivery/ClangTidy"

# Run clang-tidy on changes, specify depth of commits with '-d'
alias tidy="taskset 0xFFFF /usr/bin/python $clangTidyDir/parallel-clang-tidy-diff.py -p $buildDir -j 4"
# Run clang-tidy on a file
alias tidy="taskset 0xFFFF /usr/bin/python $clangTidyDir/parallel-clang-tidy.py -p $buildDir -j 4"
# Normal cmake
alias ncmake="cd $buildDir && cmake $srcDir -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCTAGS_ENABLED=False -GNinja -DCMAKE_CXX_COMPILER=clang++-5.0 -DCMAKE_C_COMPILER=clang-5.0 -DPYTHON_EXECUTABLE:FILEPATH=/usr/bin/python2"
# Release cmake
alias rcmake="cd $buildDir && cmake $srcDir -DCMAKE_BUILD_TYPE=Release -DCTAGS_ENABLED=False -GNinja -DCMAKE_CXX_COMPILER=clang++-5.0 -DCMAKE_C_COMPILER=clang-5.0 -DPYTHON_EXECUTABLE:FILEPATH=/usr/bin/python2"
# Compile
alias compile="numactl -C !0 ninja $1"

# Tab completion for ninja targets
_ninjaComplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(ninja -t targets all 2> /dev/null | grep -v / | awk -F ':' '{print $1}')" -- $cur))
}
compdef _ninjaComplete ninja
compdef _ninjaComplete compile

function findTests() {
    find "$buildDir/" -type f -executable -name "*$1*"
}

function execTests() {
    findTests $1 | xargs -n1 command
}

function nukeit() {
    echo "Wiping build directory"
    cd "$buildDir"
    find . ! -name 'compile_commands.json' -delete
    ncmake
}

# Timed build
function cgmake() {
    ccache -z
    /usr/bin/time -f "Time: %E\t CPU: %P" numactl -C !0 ninja $1
    ccache -s
}

