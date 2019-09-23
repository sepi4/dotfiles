#
# ~/.bashrc
#


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

  export PS1="$GREEN_BOLD[$BLUE_BOLD\u$RED_BOLD@$CYAN_BOLD\h $YELLOW_BOLD\W$GREEN_BOLD]\$(__git_ps1 '$NO_COLOUR($GREEN%s$NO_COLOUR)')$NO_COLOUR\$ "


}

prompt

VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR
export BROWSER=/usr/bin/google-chrome-stable
alias config='/usr/bin/git --git-dir=/home/sepi4/.cfg/ --work-tree=/home/sepi4'
alias ea='nvim ~/.config/awesome/'

