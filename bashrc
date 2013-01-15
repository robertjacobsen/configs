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
    git branch 2>/dev/null | grep "^*" | sed -e "s/^* \(.*\)$/ ‹\1›/" -e "s/[()]+//g"
}

# Add some easier colours
if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    MAGENTA=$(tput setaf 9)
    ORANGE=$(tput setaf 172)
    GREEN=$(tput setaf 190)
    PURPLE=$(tput setaf 141)
    WHITE=$(tput setaf 256)
else
    MAGENTA=$(tput setaf 5)
    ORANGE=$(tput setaf 4)
    GREEN=$(tput setaf 2)
    PURPLE=$(tput setaf 1)
    WHITE=$(tput setaf 7)
fi
BOLD=$(tput bold)
RESET=$(tput sgr0)

PS1="\[$BOLD$ORANGE\]\h\[$RESET$BOLD$WHITE\] :: \[$GREEN\]\$(pwd)\[$RESET$BOLD$WHITE\]\$([[ -n \$(__git_ps1) ]])\[$PURPLE\]\$(current_branch)\[$RESET$BOLD$WHITE\] $ \[$RESET\]"
PS2="\[$ORANGE\]→ \[$RESET\]"

#UH="\[\033[02;32m\]\u\033[00m\] / \033[01;34m\]nef\[\033[00m\] :"
#PS1="$UH \w\[\033[1;36m\]\$(current_branch)\[\033[00m\]\n\$ "

# Set the title of the terminal to the current hostname.
echo -ne "\033]0;$HOSTNAME\007"

export LC_ALL=en_US.UTF-8

# Load aliases
. ~/configs/aliases

# Load git auto-completion
. ~/configs/git-completion.bash

# Fix PATH for homebrew
PATH=/usr/local/bin:/usr/local/share/npm/bin:${PATH}

# Always have 256 color
if [[ $STY ]]; then
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi

# Add SSH-agent for the win. Carefully stolen from the ZSH ssh-agent plugin,
# which was based off of http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html
SSH_ENV=$HOME/.ssh/environment

function start_agent {
  /usr/bin/env ssh-agent | sed 's/^echo/#echo/' > $SSH_ENV
  chmod 600 $SSH_ENV
  . $SSH_ENV > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "$SSH_ENV" ]; then
  . $SSH_ENV > /dev/null
  ps -ef | grep $SSH_AGENT_PID | grep ssh-agent$ > /dev/null || {
    rm $SSH_ENV;
    start_agent;
  }
else
  start_agent;
fi
