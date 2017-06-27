# export PS1="\u@\h:\w\$ "
export PS1='\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00m\]\$ '

# ls  aliases
alias ls='ls -G'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Print screenfetch information at startup
if [ -f /usr/bin/neofetch ] || [ -f /usr/local/bin/neofetch ] ; then
    neofetch;
fi

# Include bash alias file if it exists
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Colored manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'

# added by Anaconda2 4.4.0 installer
export PATH="$HOME/anaconda2/bin:$PATH"

# Only enter SSH password once per session
AGENT=`ssh-agent`
IFS=$';|\n'
for LINE in $AGENT; do
  if [[ $LINE == SSH* ]]; then
    export $LINE
  fi
done
unset IFS
`ssh-add`

# include local additions/modifications if they exist
if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi
