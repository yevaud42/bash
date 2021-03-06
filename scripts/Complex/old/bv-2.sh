#!/bin/bash -f
#
# This file creates and/or adjusts the values in the shell's environment
# to configure various aspects of the shell, including:
#
#  - setting variables to adjust BASH itself
#  - External unix apps that examine environment variables for various
# 	purposes - including settings customization and behavior modification.
#  - Setting variables used internally by user-created aliases and/or functions.
#
#  NOTE:  The PATH variable is adjusted elsewhere (bash_paths) due to its
# importance and frequent need for adjustment.


###########################################################################
# Set the sudo password for the aliases that automate providing the password.
# (Yes, I know this is mind-blowingly dumb... but I doubt the risk is really anything to worry about
# on my home machine.)
#
export _SP=r4t5y6u7i8


##############
# Setup some environment variables for storing preferences referenced
# in other scripts during the course of a session..
#
 
# prevents less from leaving an empty screen at the end of output
export LESS="-X"
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

########################################################################
# Adjust the options used by the LS program ... these are picked up by 
# the aliases in bash_aliases so that standard shortcuts for listing
# files will provide the behavior specified in _LSOPTS
#
if [ "$TERM" != "dumb" ]; then
	if ( .utilAppleCheck  ) ; then
		# if this succeeded then we know this is not a mac.
		export _HOST_TYPE="Apple"
		export LSOPT_COLOR="-G"
		export LSOPT_GROUPFOLDERS="-g"
		export LSOPT_SHOWHIDDEN="-A"
		export LSOPT_OSCUSTOM="-l -F -h"
	else
		export _HOST_TYPE="Linux"
		export LSOPT_COLOR="--color=always"
		export LSOPT_GROUPFOLDERS="--group"
		export LSOPT_SHOWHIDDEN="-A"
		export LSOPT_OSCUSTOM="-l -X -F -h"
	fi
	export _LSOPTS=" $LSOPT_OSCUSTOM $LSOPT_COLOR $LSOPT_GROUPFOLDERS "
fi


#
#  Synergy setup
######################################################
export SYNERGY_HOST=192.168.3.36
export SYNERGY_SCREEN_NAME=Leguin
export SYNERGY_ROOT=/Places/Applications/Synergy
export SYNERGY_CONFIG=$SYNERGY_ROOT/synergy.conf
export SYNERGY_HOSTOPTS=" -d INFO "

# adds a touch of color;l user prompt in green, root prompt in red
export COLOR_BLACK='\[\033[01;30m\]'
export COLOR_RED='\[\033[00;31m\]'
export COLOR_GREEN='\[\033[01;32m\]'
export COLOR_YELLOW='\[\033[01;33m\]'
export COLOR_BLUE='\[\033[01;34m\]'
export COLOR_PURPLE='\[\033[00;35m\]'
export COLOR_VIOLET='\[\033[00;35m\]'
export COLOR_CYAN='\[\033[01;36m\]'
export COLOR_WHITE='\[\033[01;37m\]'

#
#  Fonts I use a lot
####################################
export MiscFixed='-misc-fixed-medium-r-normal--*-110-*'
export MiscFixedSmall='-misc-fixed-medium-r-normal--*-100-*'
export MiscFixedTiny='-misc-fixed-medium-r-normal--*-80-*'
export MiscFixedLarge='-misc-fixed-medium-r-normal--*-140-*'

