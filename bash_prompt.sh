#
# Set the command prompt format to my liking by specifying the
# environment variable "PS1".  There is also a PS2 for use when
# running in a subshell, but I do that so seldom who cares...
#

# older prompt settings stored as comments...
#export PS1="[\h]:\w\n \u@\t} \\$>\[$(tput sgr0)\]"
#export PS1="\[\e[34;1m\]\u@\[\e[33;1m\]\H> \[\e[0m\]"
#
if [ "$TERM" = "linux" ]
then
	# we are not on a console, so assume an xterm and the ability to set the title thereof.
	# via escape sequences
	PS1_PREFIX=""
	PS1_POSTFIX="\$> "
else
	PS1_PREFIX="\[\e]2;\u@\H (\@) \w\a\e[32;1m\]"
	PS1_POSTFIX="\$>\[$(tput sgr0)\]\[\e[0m\]"
fi

export PS1="${PS1_PREFIX}\[\e[34;1m\]\u@\h \w\n#\# (\t) j=\j ../\W ${PS1_POSTFIX}"

# if [ "$TERM" = "linux" ]
# then
# 	#we're on the system console or maybe telnetting in
# 	#export PS1="\[\e[32;1m\]\u@\H > \[\e[0m\]"
# 	export PS1="\[\e[32;1m\]\[\e[34;1m\][#\!:\j jobs] @\t\$>\[$(tput sgr0)\]\[\e[0m\]"
# else	
# 	#we're not on the console, assume an xterm
#	export PS1="\[\e]2;\u@\H \w\a\e[32;1m\]>\[\e[0m\] " 
#	export PS1="\[\e]2;\u@\H (\@) \w\a\e[32;1m\]\[\e[34;1m\][#\!:\j jobs] @\t\$>\[$(tput sgr0)\]\[\e[0m\]"
#fi
