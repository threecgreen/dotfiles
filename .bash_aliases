# vim: filetype=sh
# Case insensitive grep by default
alias grep='grep -i --color=auto'

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
    alias vim="nvim"
else
    alias nvim="vim"
fi

connect-gerrit() {
    [ $1 ] || { echo "No repository specified" >&2; return 1; }
    git submodule update --init
    git remote add gerrit ssh://gerrit.belvederetrading.com:29418/$1
}

setup-git() {
    [ $1 ]    || { echo "No repository specified" >&2; return 1; }
    git clone ssh://gerrit.belvederetrading.com:29418/$1
    cd $1
    connect-gerrit $1
}

# Local variables
BUILD_DIR="/build/cgreen/laser-build"
BUILD_DIR2="/build/cgreen/laser-build2"
HARBOR_DIR="/build/cgreen/git/Harbor"
HARBOR_DIR2="/build/cgreen/git/Harbor2"
PYTHON_DIR="$HARBOR_DIR/Python"
LASER_DIR="$HARBOR_DIR/Laser"
LASER_DIR2="$HARBOR_DIR2/Laser"
CLANG_TIDY_DIR="$LASER_DIR/ContinuousDelivery/ClangTidy"
VIRTUALENV_DIR="$HOME/.envs"
ANALYZE_PYTHON="$VIRTUALENV_DIR/analyze/bin/python"

# Shortcut to compile with all cores
compile() {
    ninja $@
}
# Completion function for `compile`
__get_targets() {
  dir="."
  if [ -n "${opt_args[-C]}" ];
  then
    eval dir="${opt_args[-C]}"
  fi
  file="build.ninja"
  if [ -n "${opt_args[-f]}" ];
  then
    eval file="${opt_args[-f]}"
  fi
  targets_command="ninja -f \"${file}\" -C \"${dir}\" -t targets all"
  eval ${targets_command} 2>/dev/null | grep -v / | cut -d: -f1
}
__targets() {
  local -a targets
  targets=(${(fo)"$(__get_targets)"})
  _describe 'targets' targets
}
_compile() {
  _arguments '*::targets:__targets'
}
# Zsh completion
compdef _compile compile

# Find executable in build directory excluding .so files
find-exec() {
    fd -t x -E '**/*.so' "$1"
}

# Run all executables according matching a glob
exec-tests() {
    fd -t x -E '**/*.so' "$1" -x sudo
}

# Run clang-tidy on changes, specify depth of commits with '-d'
alias tidy="python $CLANG_TIDY_DIR/parallel-clang-tidy-diff.py -p $BUILD_DIR -j $(nproc --all)"
# Run clang-tidy on a file
alias tidy-file="python $CLANG_TIDY_DIR/parallel-clang-tidy.py -j $(nproc --all) -p $BUILD_DIR"
# Run clang-format on changes
alias clang-fmt="python $CLANG_TIDY_DIR/ClangFormatter.py -t git -p $HARBOR_DIR"
# Run clang-format on dir
alias clang-fmt-dir="python $CLANG_TIDY_DIR/ClangFormatter.py -t directory -p"
# Build validation
alias validate="python $HARBOR_DIR/Python/BuildUtils/BuildUtils/GenericBuildValidation/ValidateBTBuild.py --projectRoot $LASER_DIR --stepDirectory $LASER_DIR/BuildValidation"
# IWYU
alias iwyu="/usr/bin/python $LASER_DIR/ContinuousDelivery/IWYU/iwyu.py -build $BUILD_DIR -src $LASER_DIR"

# Laser build validation
val-laser() {
    local val_processor="Python/PyCD/PyCD/Sonar/BuildValidationCommenter/GenericBuildProcessor.py"
    if [[ $# > 0 ]] && [[ $1 = '2' ]]; then
        $ANALYZE_PYTHON $HARBOR_DIR2/$val_processor -R $LASER_DIR2 -d BuildValidation
    else
        $ANALYZE_PYTHON $HARBOR_DIR/$val_processor -R $LASER_DIR -d BuildValidation
    fi
}

# Normal cmake
ncmake() {
    if [[ $# > 0 ]] && [[ $1 = '2' ]]; then
        ENABLE_UBSAN=1 cmake $LASER_DIR2 \
            -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCTAGS_ENABLED=False -GNinja
    else
        ENABLE_UBSAN=1 cmake $LASER_DIR \
            -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCTAGS_ENABLED=False -GNinja
    fi
}

# Release cmake
rcmake() {
    if [[ $# > 0 ]] && [[ $1 = '2' ]]; then
        cmake $LASER_DIR2 -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCTAGS_ENABLED=False -GNinja
    else
        cmake $LASER_DIR -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCTAGS_ENABLED=False -GNinja
    fi
}

# Wipe build directory and re-run cmake
nukeit() {
    if [[ $# > 0 ]] && [[ $1 = '2' ]]; then
        echo "Wiping build 2 directory..."
        cd $BUILD_DIR2
    else
        echo "Wiping build directory..."
        cd $BUILD_DIR
    fi
    find . ! -name 'compile_commands.json' -delete
    ncmake $@
}

# Timed build
tcmake() {
  ccache -z
  /usr/bin/time -f "Time: %E\t CPU: %P" ninja $1
  ccache -s
}

# GDB
cgdb() {
    sudo -E ASAN_OPTIONS=abort_on_error=1 gdb --args "$@"
}

# Glances
alias glances="/usr/bin/python -m glances"

# Pylint
alias btpylint="pylint --rcfile="$HARBOR_DIR/Python/pylint.cfg""

# Gitlist
alias gitlist="$HOME/.envs/gitlist/bin/python $HOME/bin/gitlist.py"

# Find latest log
latest-log() {
    local logDir="/var/btlogs/unprivileged/$1"
    echo "$logDir/$(ls -At "$logDir" | awk 'NR==1 { print $1 }')"
}

# Find replace in working directory
find-replace() {
    [ $1 ]  || { echo "No search term specified" >&2; return -1 }
    [ $2 ]  || { echo "No replace term specified" >&2; return -1 }
    rg -l $1 | xargs sed -ri "s|$1|$2|g"
}

# Delete one or more git branches
rm-branch() {
    [ $1 ] || { echo "Must specify at least one branch" >&2; return -1 }
    for b in $@
    do
        git branch -D "$b"
    done
}

# Clean python hydra deployments older than a week
clean-python() {
    sudo find /var/cache/btpython -ctime +7 -delete
}

clean-laser() {
    sudo find /usr/local/bin -name 'BT.*' -ctime +7 -delete
}

# Poseidon
ALGO_ID=17617
create-poseidon() {
    local so_path
    if [ "$#" = 1 ] && [ "$1" = '2' ]; then
        so_path="$BUILD_DIR2/BT.Poseidon/BT.Poseidon.so"
    else
        so_path="$BUILD_DIR/BT.Poseidon/BT.Poseidon.so"
    fi
    sudo ln -sf $so_path /usr/local/lib
}
alias start-laser="sudo hydra instance start Laser cgreen_theo --soft-only"
alias reg-poseidon="sudo hydra algorithm register cgreen_theo $ALGO_ID --force"
alias start-poseidon="sudo hydra algorithm start cgreen_theo $ALGO_ID --force"
alias stop-poseidon="sudo hydra algorithm stop cgreen_theo $ALGO_ID --force"
alias unreg-poseidon="sudo hydra algorithm unregister cgreen_theo $ALGO_ID --force"

