# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

current_branch() {
    git branch 2>/dev/null | grep "^*" | sed -r -e "s/^\*\s+(.*?)$/ ‹\1›/" -e "s/[()]+//g"
}

UH="\u@\h" # Default
#UH="\[\033[01;31m\]karnage\[\033[00m\]" # I use this for my development box to differnetiate it.
PS1="$UH:\w\[\033[1;36m\]\$(current_branch)\[\033[00m\]\$ "

# Load aliases
. ~/configs/aliases

# Add SSH-agent for the win. Carefully stolen from the ZSH ssh-agent plugin,
# which was based off of http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html
SSH_ENV=$HOME/.ssh/environment

function start_agent {
  /usr/bin/env ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
  chmod 600 ${SSH_ENV}
  . ${SSH_ENV} > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  . ${SSH_ENV} > /dev/null
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi
