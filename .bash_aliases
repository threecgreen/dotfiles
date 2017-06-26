# Bash aliases file

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
