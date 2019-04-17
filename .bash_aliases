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
alias ll="ls -lFh"
alias la="ls -AlFh"
alias l="ls -1Fh"
alias lt="ls -ltFh"
alias lat="ls -ltFAh"

# Make parent directories if they don"t exist and verbose output
alias mkdir="mkdir -pv"

# Alias nvim to vim and vi if installed
if [[ -f /usr/local/bin/nvim ]] || [[ -f /usr/bin/nvim ]]; then
    alias vi="nvim"
    alias vim="nvim"
else
    alias nvim="vim"
fi

# Add custom binaries/scripts
export PATH=$PATH:$HOME/bin

# Use bat instead of cat if installed
cat() {
    if [ -f $HOME/bin/bat ]; then
        $HOME/bin/bat -n --theme=GitHub "$@"
    else
        /usr/bin/cat "$@";
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

# Tab completion for ninja targets
_ninjaComplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(ninja -t targets all 2> /dev/null | grep -v / | awk -F ':' '{print $1}')" -- $cur))
}
complete -F _ninjaComplete ninja

# Shortcut to compile with all cores
alias compile="numactl -C !0 ninja $1"
complete -F _ninjaComplete compile
# complete -F _ninjaComplete compileNoSync

# Find executable in build directory
findExec() {
    find "$buildDir/" -type f -executable -name "*$1*"
}

# Run all executables according matching a glob
execTests() {
    findTests $1 | xargs -n1 command
}

# Run clang-tidy on changes, specify depth of commits with '-d'
alias tidy="numactl -C !0 python $clangTidyDir/parallel-clang-tidy-diff.py -p $buildDir -j $(nproc --all)"
# Run clang-tidy on a file
alias tidyFile="numactl -C !0 python $clangTidyDir/parallel-clang-tidy.py -j $(nproc --all) -p $buildDir"
# Run clang-format on changes
alias clangFmt="python $clangTidyDir/ClangFormatter.py -t git -p $harborBase"
# Run clang-format on dir
alias clangFmtDir="python $clangTidyDir/ClangFormatter.py -t directory -p"
# Build validation
alias validate="python $harborBase/Python/BuildUtils/BuildUtils/GenericBuildValidation/ValidateBTBuild.py --projectRoot $srcDir --stepDirectory $srcDir/BuildValidation"

function fixChronosGenerated() {
    # Fix line endings in generated file
    if [ -f "$srcDir/BT.ChronosClient.Generated/Private/ChronosScripts.cpp" ]; then
        sed -i 's///g' "$srcDir/BT.ChronosClient.Generated/Private/ChronosScripts.cpp"
    fi
}

# For cquery
function cpCompileCommands() {
    cp "$buildDir/compile_commands.json" "$harborBase"
}

# Normal cmake
function ncmake() {
    cd $buildDir
    cmake $srcDir -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCTAGS_ENABLED=False -GNinja || exit 1
    fixChronosGenerated
    cpCompileCommands
}

# Release cmake
function rcmake() {
    cd $buildDir
    cmake $srcDir -DCMAKE_BUILD_TYPE=Release -DCTAGS_ENABLED=False -GNinja || exit 1
    fixChronosGenerated
    cpCompileCommands
}

# Wipe build directory and re-run cmake
function nukeit() {
  echo "Wiping build directory..."
  cd $buildDir
  find . ! -name 'compile_commands.json' -delete
  ncmake
}

# Timed build
function tcmake() {
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

# Gitlist
alias gitlist="$HOME/.envs/gitlist/bin/python $HOME/bin/gitlist.py"

# Find latest log
function latestLog() {
    local logDir="/var/btlogs/unprivileged/$1"
    echo "$logDir/$(ls -At "$logDir" | awk 'NR==1 { print $1 }')"
}

