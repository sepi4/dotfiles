#
# ~/.bashrc
#

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
function prompt
{

  local BLACK="\[\033[0;30m\]"
  local DARKGRAY="\[\033[1;30m\]"
  local BLUE="\[\033[0;34m\]"
  local BLUE_BOLD="\[\033[1;34m\]"
  local GREEN="\[\033[0;32m\]"
  local GREEN_BOLD="\[\033[1;32m\]"
  local CYAN="\[\033[0;36m\]"
  local CYAN_BOLD="\[\033[1;36m\]"
  local RED="\[\033[0;31m\]"
  local RED_BOLD="\[\033[1;31m\]"
  local PURPLE="\[\033[0;35m\]"
  local PURPLE_BOLD="\[\033[1;35m\]"
  local YELLOW="\[\033[0;33m\]"
  local YELLOW_BOLD="\[\033[1;33m\]"
  local WHITE="\[\033[0;37m\]"
  local WHITE_BOLD="\[\033[1;37m\]"
  local NO_COLOUR="\[\033[0m\]"


  . ~/git-prompt.sh
  export GIT_PS1_SHOWDIRTYSTATE=1

  # if [[ "$(xrandr | grep VGA)" != "" ]]; then
  #   export PS1="$RED[$BLUE_BOLD\u$GREEN_BOLD@$CYAN_BOLD\h $YELLOW_BOLD\W$RED]\$(__git_ps1 '$NO_COLOUR($GREEN%s$NO_COLOUR)')$NO_COLOUR\$ "
  # else
  #   export PS1="[\u@\h \W] \$(__git_ps1 '$NO_COLOUR($GREEN%s$NO_COLOUR)')$NO_COLOUR\$ "
  # fi

  export PS1="$GREEN_BOLD[$BLUE_BOLD\u$RED_BOLD@"
  PS1+="$CYAN_BOLD\h $YELLOW_BOLD\W$GREEN_BOLD]"
  PS1+="\$(__git_ps1 '$NO_COLOUR($GREEN%s$NO_COLOUR)')$NO_COLOUR\n\$ "


}
prompt

VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR
# export BROWSER=/usr/bin/chromium
export BROWSER=/usr/bin/firefox
alias config='/usr/bin/git --git-dir=/home/sepi4/.cfg/ --work-tree=/home/sepi4'
alias ea='nvim ~/.config/awesome/'
export PATH=~/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/sbin\
:$HOME/myScripts:/var/lib/snapd/snap/bin
complete -cf sudo # for autocompletion
TERM=xterm-256color
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"
alias screen='TERM=xterm-256color screen'
alias monitors='xrandr --output DP-1 --pos 0x-1080'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'



export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
