# vim:ft=zsh ts=2 sw=2 sts=2
# Custom oh-my-zsh theme with lambda prompt character
#
# Taken from agnoster theme
prompt_git() {
  (( $+commands[git] )) || return
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path branch_color

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      branch_color="%{$fg[yellow]%}"
    else
      branch_color="%{$fg[green]%}"
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    # zstyle ':vcs_info:*' stagedstr '✚'
    # zstyle ':vcs_info:*' unstagedstr '●'
    # zstyle ':vcs_info:*' formats ' %u%c'
    # zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    # ${vcs_info_msg_0_%% }
    echo -n "${branch_color}${ref/refs\/heads\//$PL_BRANCH_CHAR }%{$reset_color%}${mode} "
  fi
}

pshort_dir() {
  $HOME/.local/bin/pshort $PWD 18
}

virtualenv_info() {
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo " [${VIRTUAL_ENV:t}]"
}

anaconda_info() {
  # Depending on the conda version, either might be set. This
  # variant works even if both are set.
  local _path=$CONDA_ENV_PATH$CONDA_PREFIX
  if ! [ -z "$_path" ]; then
    echo " [$(basename $_path)]"
  fi
}

local ret_status="%(?:%{$fg_bold[green]%}λ:%{$fg_bold[red]%}λ)"

PROMPT='${ret_status} %{$fg[cyan]%}$(pshort_dir)%{$reset_color%} $(prompt_git)→ '
# %* is 24-hour format, with seconds
# RPROMPT='%{$fg[white]%}%* %{$fg[blue]%}$(virtualenv_info)$(anaconda_info)%{$reset_color%}'
RPROMPT='%*%{$fg[blue]%}$(virtualenv_info)$(anaconda_info)%{$reset_color%}'

