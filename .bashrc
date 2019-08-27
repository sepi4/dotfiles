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

PS1="$RED[$BLUE_BOLD\u$GREEN_BOLD@$CYAN_BOLD\h $YELLOW\W$RED]$NO_COLOUR$ $NO_COLOUR"
# PS1='[\u@\h \W]\$ '
}

prompt

VISUAL=vim; export VISUAL EDITOR=vim; export EDITOR
alias config='/usr/bin/git --git-dir=/home/sepi4/.cfg/ --work-tree=/home/sepi4'
alias ea='vim ~/.config/awesome/'
