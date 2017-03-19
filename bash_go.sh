#!/usr/bin/bash -f
#
# This file implements the ".go" command, which allows the user
# to maintain a set of aliases for directory paths.  it provides
# the following facilities:
#
# .go                          # Prints usage information, and indicates number of aliases stored.
# .go <alias>                  # change working directory to the folder associated with the alias
# .go list                     # Prints list of aliases and associated locations to stdout
# .go add <alias> <location>   # Adds an alias to the collection, and saves the result to the datafile.
# .go remove <alias>           # Removes an alias from the collection, and updates the datafile.
# .go load [datafile]          # resets the 
# .go save [datafile]          # Saves the go aliases to file.  If {datafile} is specified, the data is
#                              # written to the indicated file instead of DEFAULT_DATAFILE.
#                              #If <datafile> is specified,
#                              # it saves to that location,
#

# Set this to the default location for your data file.  By default, I keep it in a
# ~/.bash folder, using the bash_go_data.txt filename.
DEFAULT_DATAFILE="$HOME/.bash/bash_go_data.txt"

#
# The list of "reserved" keys that cannot be used aas aliases.
GO_RESERVED=(add remove list load save help usage)
unset GO_LIST
declare -A -x GO_LIST


#
# print out usage information to stdout.  Optional argument specifies
# an additional message for targeted topic.
#
function .go_usage()
{
    local topic="${1,,?}"; # lowercase conversion

    if [[ -z "$topic" || "$topic" = "help" ]] ; then
	cat << EOF
Usage: .go [command] [arguments]

  .go | .go help               Print usage information, and display number of stored aliases.
  .go <alias>                  Change working directory to the folder associated with the alias
  .go list                     Print list of aliases and associated locations to stdout
  .go add <alias> <location>   Add an alias to the collection, and saves the result to the datafile.
  .go remove <alias>           Remove an alias from the collection, and update the datafile.
  .go load [datafile]          resets the 
  .go save [datafile]          Save the .go aliases to file.  If [datafile] is specified, the data is
                               written to the indicated file instead of DEFAULT_DATAFILE.
EOF
   	printf "\n  There are currently %d aliases defined.\n" ${#GO_LIST[*]};
        return 0;
    fi
    
    if [ "$topic" = "add" ] ; then
	echo "   Usage: ";
	echo "     .go add <alias> <location>";
	echo "   Where: ";
	echo "     <alias> is single word name, without whitespace";
	echo "     <location> is the pathanme to expand upon execution of alias.";
	echo "   Notes:";
	echo "     Variables in the pathname are evaluated each time the command is used,";
	echo "     allowing the user to modify their values as desired between invocations.";
	return 0;
    fi
    if [ "$topic" = "remove" ] ; then
	cat << EOF
Usage:
    .go remove <alias>
Where:
    <alias> is the name of an existing alias in the list of named locations.
Notes:
    Available locations can be listed via the '.go list' command.
EOF
	return 0;
    fi
    return 0;
}   

function .go_save()
{
    local datafile="$1"; # name of the file to save to
    local old_ifs=${IFS}; # remember IFS value as it was when we began
    
    if [ -z "$datafile" ] ; then
	datafile="$DEFAULT_DATAFILE";
    fi

    
    touch $datafile
    if [ ! -f "$datafile" ] ; then
	echo "Error creating datafile '$datafile'.";
	return -1;
    fi

    echo "#" > $datafile
    echo -n "# Timestamp: " >> $datafile
    date >> $datafile
    echo "#" >> $datafile
    echo "# This file defines the array of defined aliases usee by the" >> $datafile
    echo "# '.go' shell command.  It is read in by the go shell script" >> $datafile
    echo "# on initialization, and is written to by the 'save' command." >> $datafile
    echo "# An automatic save is also invoked when using the 'add'" >> $datafile
    echo "# and 'remove' commands, to ensure the datafile matches the " >> $datafile
    echo "# state of the alias list." >> $datafile
    echo "#" >> $datafile
    echo "" >> $datafile
    
    IFS=" ";
    for key in ${!GO_LIST[*]} ; do
	printf "%s=%s\n" "$key" "${GO_LIST[$key]}" >> $datafile
    done
    IFS=${old_ifs};
    echo "Wrote ${#GO_LIST[*]} aliases to file: '$datafile'."
    return 0;
}

#
# Load in the alias list from file.  Notes on code to read file line by line:
# 
# *  IFS='' (or IFS=) prevents leading/trailing whitespace from being trimmed.
# *  -r prevents backslash escapes from being interpreted.
# *  "|| [[ -n $line ]]" prevents the last line from being ignored if it doesn't end with
#    a \n (since read returns a non-zero exit code when it encounters EOF).#
function .go_load()
{
    # Set location of the datafile to either the argument passed in, or the default.
    local datafile=$1
    local count=0
    if [ -z "$datafile" ] ; then
	datafile="$DEFAULT_DATAFILE";
    fi

    echo "Loading destinations from file: '$datafile'."
    local old_ifs=${IFS}
    while IFS='' read -r line || [[ -n "$line" ]]; do
	if [[ "${line[0]}" == \#* ]] ; then
	    #echo "Skipping line: '$line'.";
	    continue;
	fi
	#echo "Processing line: '$line'.";
	IFS='='
	local array=($line)
	local key=${array[0]}
	local path=${array[1]}
	if [ -n "$path" ] ; then  
		#echo "[\"$key\"] = \"$path\".";
		GO_LIST[$key]=$path;
		count=`expr $count + 1`;
	fi
    done < "$datafile"
    echo "$count destinations loaded..."
    IFS=$oldIFS
}

#
# Remove the indicated alias from the list of destinations.
#
function .go_remove()
{
    local name="${1,,?}" ; #lowercase conversion

    if [ -z "$name" ] ; then
	echo "Missing alias name.  Should be a singlle word, no whitespace."
	.go_usage "remove"
	return 0;
    fi
    if [ -z "${GO_LIST[$name]}" ] ; then
	echo "No alias '$name' exists.  Please see '.go list' for list of"
	echo "existing aliases."
	.go_usage "remove"
	return 0;
    fi
    if [ -z "$GO_LIST[$name]" ] ; then
	echo "Alias '$name' not found.  Please check the list of defined"
	echo "aliases using '.go list' command."
	.go_usage "remove"
	return 0;
    fi
    
    unset "GO_LIST[$name]"
    return 0;
}

function .go_add()
{
    local name="${1,,?}" ; #lowercase conversion
    local path="$2"; 

    if [ -z "$name" ] ; then
	echo "Missing alias name.  Should be a single word, no whitespace."
	.go_usage "add"
	return 0;
    fi
    if [ -z "path" ] ; then
	echo "Missing alias location.   Should be a shell-compatible pathname.  "
	.go_usage "add"
	return 0;
    fi

    GO_LIST[$name]=$path;
    .go_save
    return 0;
}

#
# List the defined go aliases to stdout.
#
function .go_list()
{
    local old_ifs=${IFS}; # remember old value for later
    
    echo "The following ${#GO_LIST[*]} aliases are defined:"
    IFS=" "
    for key in ${!GO_LIST[*]} ; do
	printf "%10s  = %s\n" "$key" "${GO_LIST[$key]}"
    done
    IFS=${old_ifs}
    return 0;
}    

function .go_invoke()
{
    local name="${1,,?}" ; # lower-case conversion.
    local path=${GO_LIST[$name]}
    local old_ifs=${IFS}
    
    if [ -z "$path" ] ; then
	echo 
	echo "[ERROR] - Invalid destination name."
	echo "     No go alias '$name' exists."
	echo "     Use the 'add' command to add an alias, or"
	echo "     the 'list' command to see the list of available aliases."
	echo ""
	return 0;
    fi

    # use eval to perform any expansion that would happen on the command line
    # so that things like $HOME and ~ get expanded as expected.
    if [ -n "$path" ]; then
	eval "truepath=\"$path\"";
	if [ -x "$truepath" ]; then
	    echo "New Location: '$truepath'." ;
	    eval "cd \"$truepath\"";
	else
	    echo "Destination '$path' not valid..";
	    echo "(expanded to: '$truepath')"
	fi
    fi
}

function .go_checkReserved()
{
    local name="${1,,?}" ; # lower-case conversion
    local old_ifs=${IFS}; # remember old value for later

    IFSS=" "
    for reserved in ${GO_RESERVED[*]} ; do
	if [ "$name" = "$reserved" ] ; then
	    IFS=${old_ifs}
	    return 1;
	fi
    done
    IFS=${old_ifs}
    return 0;
    done
    return 0;
}    
    local old_ifs=$IFS
    for reserve in 
#
# This is the main command, which allows the user to enter the .go command
# along with a specified alias to change the working directory to the
# folder previously associated with that alias.
#
# There are two reserved alias names that actually implement commands used
# to manage the alias list.  These are 'list', 'add', and 'remove'.  These
# values are reserved for the commands they implement, and thus are not valid
# as alias names to be associated with a destination folder.
#
function .go()
{
    local path
    local name="${1,,?}" ; # lower-case conversion.

    if [[ -z "$name" || "$name" = "help" || "$name" = '?' ]] ; then
	.go_usage
	return 0;
    fi

    if [ "$name" = "load" ] ; then
	.go_load $2
	return 0;
    fi

    if [ "$name" = "save" ] ; then
	.go_save $2
	return 0;
    fi
    
    if [ "$name" = "list" ] ; then
	.go_list 
	return 0;
    fi
    
    if [ "$name" = "add" ] ; then
	.go_add $2 $3
	return 0;
    fi

    if [ "$name" = "remove" ] ; then
	.go_remove $2
	return 0;
    fi
    

    # If not a command, then assume its the go action itself, and the "$name" argument
    # is the alias name to invoke.
    .go_invoke "$name"

}

# Last but not least, load the data file to initialize the
# set of aliases.  I prefer to name my commands with a preceding
# dot, but I use this one often enough I alias 'go' to '.go'.
.go load
alias go=.go
