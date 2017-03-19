	
#
# Load in the gems of war database info from the cut & paste data 
# that I grabbed off their website.  The data is in a specific, loose,
# multi-line format that requires some massaging to get right.
#jj

function gow_load()
{
    # Set location of the datafile to either the argument passed in, or the default.
    local datafile=$1
    local count=1
    if [ -z "$datafile" ] ; then
	datafile="$DEFAULT_DATAFILE";
    fi

    unset GOW_LINES
    declare -a -x GOW_LINES

    echo "Loading cards from file: '$datafile'."
    
    local old_ifs=${IFS}
    while read -r line || [[ -n "$line" ]]; do
	if [[ $line =~ "#([0-9]+)" ]] ; then
	    CardName = $GOW_LINES[$count-2]
	    Cards[$CardName]=$GOW_LINES[$count-
	GOW_LINES[$count]=$line;
	if (($count % 10 == 0)) ; then
	    echo -n "."
	fi

	if (($count % 100 == 99)) ; then
	    echo "|$count|"
	fi

	#		printf "Adding line[%d]: %s." $count "$line"
	count=`expr $count + 1`;

    done < "$datafile"


    
    printf "Read %d lines of data.\n" $count
    IFS=$oldIFS
##	if [ -n "$path" ] ; then  
#		#echo "[\"$key\"] = \"$path\".";
#		GO_LIST[$key]=$path;
#		count=`expr $count + 1`;
#	fi
#    done < "$datafile"
}

