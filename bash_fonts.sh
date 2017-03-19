#
#
# Scripting function for bash shell to manage a collection of font aliases, for use by the
# user when needing to reference fonts in shell commands.  Thus, instead of having to remember
# extremely long and complicated font names, they can just say "xterm -fn $font_small"

declare -a FONTS
export FONT_INPUT_FILE="bash_fonts.txt"

function font_load()
{
    local FONTLIST
    local entry
    while read entry
    do
	echo "Processing font alias: '$entry'.";
	name="";
	for f in $entry ; do
	    if [ "$name" = "" ] ; then
		echo "name=$f";
		name="$f";
	    else
		echo "val=$f";
		val="$f";
	    fi
	done
	echo "name=val, $name=$val.";
	echo "export ${\"$FONT_$name\"}=\"$val\"";
	export ${"$FONT_$name"}="$val";
    done < $FONT_INPUT_FILE
    
}

function font_add()
{
    echo "font_add"
}   
    
export FONTS_TERMINUS="-*-terminus-*-r-*-*-14-*-*-*-*-*-*-*"
