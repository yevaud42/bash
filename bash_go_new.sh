
.go () 
{ 
    local path;
    local name="${1,,?}";
    if [[ -z "$name" || "$name" = "help" || "$name" = '?' ]]; then
        .go_usage;
        return 0;
    fi;
    if [ "$name" = "load" ]; then
        .go_load $2;
        return 0;
    fi;
    if [ "$name" = "save" ]; then
        .go_save $2;
        return 0;
    fi;
    if [ "$name" = "list" ]; then
        .go_list;
        return 0;
    fi;
    if [ "$name" = "add" ]; then
        .go_add $2 $3;
        return 0;
    fi;
    .go_invoke "$name"
}
.go_add () 
{ 
    local name="${1,,?}";
    local path="$2";
    if [ -z "$name" ]; then
        echo "Missing alias name.  Should be a single word, no whitespace.";
        .go_usage "add";
        return 0;
    fi;
    if [ -z "path" ]; then
        echo "Missing alias location.   Should be a shell-compatible pathname.  ";
        .go_usage "add";
        return 0;
    fi;
    GO_LIST[$name]=$path;
    .go_save;
    return 0
}
.go_invoke () 
{ 
    local name="${1,,?}";
    local path=${GO_LIST[$name]};
    local old_ifs=${IFS};
    if [ -z "$path" ]; then
        echo;
        echo "[ERROR] - Invalid destination name.";
        echo "     No go alias '$name' exists.";
        echo "     Use the 'add' command to add an alias, or";
        echo "     the 'list' command to see the list of available aliases.";
        echo "";
        return 0;
    fi;
    if [ -n "$path" ]; then
        eval "truepath=\"$path\"";
        if [ -x "$truepath" ]; then
            echo "New Location: '$truepath'.";
            eval "cd \"$truepath\"";
        else
            echo "Destination '$path' not valid..";
            echo "(expanded to: '$truepath')";
        fi;
    fi
}
.go_list () 
{ 
    local old_ifs=${IFS};
    echo "The following ${#GO_LIST[*]} aliases are defined:";
    IFS=" ";
    for key in ${!GO_LIST[*]};
    do
        printf "%10s  = %s\n" "$key" "${GO_LIST[$key]}";
    done;
    IFS=${old_ifs};
    return 0
}
.go_load () 
{ 
    local datafile=$1;
    local count=0;
    if [ -z "$datafile" ]; then
        datafile="$DEFAULT_DATAFILE";
    fi;
    echo "Loading destinations from file: '$datafile'.";
    local old_ifs=${IFS};
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [[ "${line[0]}" == \#* ]]; then
            continue;
        fi;
        IFS='=';
        local array=($line);
        local key=${array[0]};
        local path=${array[1]};
        if [ -n "$path" ]; then
            GO_LIST[$key]=$path;
            count=`expr $count + 1`;
        fi;
    done < "$datafile";
    echo "$count destinations loaded...";
    IFS=$oldIFS
}
.go_save () 
{ 
    local datafile="$1";
    local old_ifs=${IFS};
    if [ -z "$datafile" ]; then
        datafile="$DEFAULT_DATAFILE";
    fi;
    touch $datafile;
    if [ !(-f "$datafile") ]; then
        echo "Error creating datafile '$datafile'.";
        return -1;
    fi;
    echo "#" > $datafile;
    echo -n "# Timestamp: " >> $datafile;
    date >> $datafile;
    echo "#" >> $datafile;
    echo "# This file defines the array of defined aliases usee by the" >> $datafile;
    echo "# '.go' shell command.  It is read in by the go shell script" >> $datafile;
    echo "# on initialization, and is written to by the 'save' command." >> $datafile;
    echo "# An automatic save is also invoked when using the 'add'" >> $datafile;
    echo "# and 'remove' commands, to ensure the datafile matches the " >> $datafile;
    echo "# state of the alias list." >> $datafile;
    echo "#" >> $datafile;
    echo "" >> $datafile;
    IFS=" ";
    for key in ${!GO_LIST[*]};
    do
        printf "%s=%s\n" "$key" "${GO_LIST[$key]}" >> $datafile;
    done;
    IFS=${old_ifs};
    echo "Wrote ${#GO_LIST[*]} aliases to file: '$datafile'.";
    return 0
}
.go_usage () 
{ 
    local topic="${1,,?}";
    if [[ -z "$topic" || "$topic" = "help" ]]; then
        cat  <<EOF
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

        printf "\n  There are currently %d aliases defined.\n" ${#GO_LIST[*]}
        return 0;
    fi;
    if [ "$topic" = "add" ]; then
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
}
cd_func () 
{ 
    local x2 the_new_dir adir index;
    local -i cnt;
    if [[ $1 == "--" ]]; then
        dirs -v;
        return 0;
    fi;
    the_new_dir=$1;
    [[ -z $1 ]] && the_new_dir=$HOME;
    if [[ ${the_new_dir:0:1} == '-' ]]; then
        index=${the_new_dir:1};
        [[ -z $index ]] && index=1;
        adir=$(dirs +$index);
        [[ -z $adir ]] && return 1;
        the_new_dir=$adir;
    fi;
    [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}";
    pushd "${the_new_dir}" > /dev/null;
    [[ $? -ne 0 ]] && return 1;
    the_new_dir=$(pwd);
    popd -n +11 2> /dev/null > /dev/null;
    for ((cnt=1; cnt <= 10; cnt++))
    do
        x2=$(dirs +${cnt} 2>/dev/null);
        [[ $? -ne 0 ]] && return 0;
        [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}";
        if [[ "${x2}" == "${the_new_dir}" ]]; then
            popd -n +$cnt 2> /dev/null > /dev/null;
