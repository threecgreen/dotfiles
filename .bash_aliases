# vim: filetype=sh
# Bash aliases file
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

# Make parent directories if they don"t exist and verbose output
alias mkdir="mkdir -pv"

# Alias nvim to vim and vi if installed
if [[ -f /usr/local/bin/nvim ]] || [[ -f /usr/bin/nvim ]]; then
    alias vi="nvim"
    alias vim="nvim"
fi

# Use bat instead of cat if installed
cat() {
    if [ -f $HOME/bin/bat ]; then
        $HOME/bin/bat -n --theme='Monokai Extended' "$@";
    else
        cat "$@";
    fi
}

connectGerrit() {
     [ $1 ] || { echo "No repository specified" >&2; return 1; }
     git submodule update --init;
    git remote add gerrit ssh://gerrit.belvederetrading.com:29418/$1;
}

setupGit() {
    [ $1 ]    || { echo "No repository specified" >&2; return 1; }
    git clone ssh://gerrit:29418/$1;
    cd $1;
    connectGerrit $1;
}

# Local variables
buildDir="$HOME/build"
harborBase="$HOME/git/Harbor"
pythonDir="$harborBase/Python"
srcDir="$harborBase/Laser"
clangTidyDir="$srcDir/ContinuousDelivery/ClangTidy"

# Sync VM Laser with laptop Laser
# alias syncPython="rsync -aP --links --no-perms --no-owner --no-group -e 'ssh -p 2222' "chiwksdev231:/home/cgreen/win/git/Harbor/Python" "$harborBase""
# alias syncLaser="rsync -aP --links --no-perms --no-owner --no-group -e 'ssh -p 2222' "chiwksdev231:/home/cgreen/win/git/Harbor/Laser" "$harborBase""
# alias syncLaserDelete="rsync -aP --links --no-perms --no-owner --no-group -e 'ssh -p 2222' --delete "chiwksdev231:/home/cgreen/win/git/Harbor/Laser" "$harborBase""

# Tab completion for ninja targets
_ninjaComplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(ninja -t targets all 2> /dev/null | grep -v / | awk -F ':' '{print $1}')" -- $cur))
}
complete -F _ninjaComplete ninja

# Shortcut to compile with all cores
# alias compile="syncLaser && numactl -C !0 ninja $1"
# alias compileNoSync="numactl -C !0 ninja $1"
alias compile="numactl -C !0 ninja $1"
complete -F _ninjaComplete compile
# complete -F _ninjaComplete compileNoSync

findTests() {
    find "$buildDir/" -type f -executable -name "*$1*"
}

execTests() {
    findTests $1 | xargs -n1 command
}

alias nvim=/usr/bin/vim
alias vimm=/usr/bin/vim

# Add binaries
export PATH=$PATH:$HOME/bin

# Run clang-tidy on changes, specify depth of commits with '-d'
alias tidy="taskset 0xFFFF /usr/bin/python $clangTidyDir/parallel-clang-tidy-diff.py -p $buildDir -j 16"
# Run clang-tidy on a file
alias tidyFile="taskset 0xFFFF /usr/bin/python $clangTidyDir/parallel-clang-tidy.py -j 16 -p $buildDir"
# alias validate="python $harborBase/Python/BuildUtils/BuildUtils/GenericBuildValidation/ValidateBTBuild.py --projectRoot $srcDir --stepDirectory $srcDir/BuildValidation"
# alias hydraBuild="hydra ci build Laser --flags '-c clang -t debug -g ninja -d /build/cjackson/hydraBuild -s /build/cjackson/Harbor -a /build/cjackson/Harbor/Laser/ContinuousDelivery/ClangTidy -z false -n0 -m0 -r true'"
# alias headerDb="compdb -p . list > tmp.json && mv compile_commands.json compile_commands.bak && mv tmp.json compile_commands.json"

function cat() {
    # Check if the program exists
    if [ -f $HOME/bin/bat ]; then
        $HOME/bin/bat -n --theme=GitHub "$@"
    else
        cat "$@"
    fi
}

function fixChronosGenerated() {
    # Fix line endings in generated file
    if [ -f "$srcDir/BT.ChronosClient/Generated/ChronosScripts.cpp" ]; then
        sed -i 's///g' "$srcDir/BT.ChronosClient/Generated/ChronosScripts.cpp"
    fi
}

# Normal cmake
alias ncmake="cd $buildDir && cmake $srcDir -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCTAGS_ENABLED=False -GNinja && fixChronosGenerated"
# Release cmake
alias rcmake="cmake $srcDir -DCMAKE_BUILD_TYPE=Release -DCTAGS_ENABLED=False -GNinja && fixChronosGenerated"

function nukeit() {
  echo "Wiping build directory"
  cd $buildDir
  find . ! -name 'compile_commands.json' -delete
  ncmake
}

# Timed build
function cgmake() {
  ccache -z
  /usr/bin/time -f "Time: %E\t CPU: %P" numactl -C !0 ninja $1
  ccache -s
  fixChronosGenerated
}

# GDB
function cgdb {
    sudo -E ASAN_OPTIONS=abort_on_error=1 gdb --args "$@"
}

# Glances
alias glances="/usr/bin/python -m glances"

# Pylint
alias btpylint="pylint --rcfile="$harborBase/Python/pylint.cfg""

# Find latest log
function latestLog() {
    local logDir="/var/btlogs/unprivileged/$1"
    echo "$logDir/$(ls -At "$logDir" | awk 'NR==1 { print $1 }')"
}

