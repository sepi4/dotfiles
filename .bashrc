#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

neofetch

VISUAL=vim; export VISUAL EDITOR=vim; export EDITOR
alias config='/usr/bin/git --git-dir=/home/sepi4/.cfg/ --work-tree=/home/sepi4'
