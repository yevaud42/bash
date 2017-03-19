# folder and file listing aliases for ls.exe and the like

export _LSOPTS='-X -h -r'

alias l='ls -l $_LSOPTS '
alias lrt='ls -lArt'
alias lt='ls -lAr'
alias lss='ls -lAS'
alias lssr='ls -lArS'
alias lsr='ls -lArS'
alias dir='ls -lA'
alias rlist='ls -lARHF'


#
# file system operations 
#####################################################################################
alias xcopy='cp -vfr $*'
alias del='rm -rfv'
alias move='mv -vf' 
alias copy='cp -vf'
alias clean='rm -fv *~ *.tmp *.temp'

#
# search and find helper aliases
#####################################################################################
alias lgrep='ls -lA \| grep -i $*'

# command history manipulation
#####################################################################################
alias h='history'
alias rr='!!'
alias r='!'
alias rp='! $* | less'

#####################################################################################
#                           ............................                            #
#            <-<><><><><>-> Package Installation Aliases <-<><><><><>->             #
#                           ............................                            #
#                                                                                   #
#  Aliases to make the use of the command-line interface for the major installers   #
#  simpler, more convenience, and overall less damaging to my poor wrist joints.    #
# ###################################################################################

#  Alias for Aptitude, a package manager invoked by "apt-get" and
#  similar.  Familiar to anyone who has installed Ubuntu in recent
#  years, and for those using one of the many Ubuntu variations (such
#  as Mint, Mythbunut, etc..)
alias .install='echo $SUDO_PASS | sudo -S apt-get install -y $*'
alias .query='apt-cache search $*'
alias .update='echo $SUDO_PASS | sudo -S apt-get update -y $*'
alias .upgrade='echo $SUDO_PASS | sudo -S apt-get upgrade -y $*'


#
# Misc aliases....
##################################################################################

alias more=less


echo "Aliases installed..." echo "==================== \\\/// ======================"
