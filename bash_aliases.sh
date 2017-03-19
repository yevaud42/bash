#
# This file holds the personal bash aliases and supporting functions that
# I employ when using the command line.
#

#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
 alias df='df -h'
 alias du='du -h'
#
# Misc :)
alias less='less -r -J'                          # raw control characters
alias more=less
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -hpF --color=tty'                 # classify files in colour, with si units & ascii type designator
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias l='ls -l'                              # long list
alias la='l -A'                              # all but . and ..
alias lc='ls -CF'                              # list in columned output...
alias ll='l'
alias lrt='l -rt'
alias lart='l -art'
alias lss='l -rS'
alias lass='l -arS'

# some short one-letter commands
alias j='jobs'
alias h='history'


alias nuke='rm -rfv'
alias del=rm
alias lnc='l --color=no'
alias vi=vim

