#!/usr/bin/bash -f
#
# This file provides common functions of general use.  It is intended to be loaded automatically
# by the bash shell before invoking other, more specific shell files.  
#
# capitalize_ichar() -- capitalize the initial character of the strings passed in.
# unquote() -- remove single or double quote marks from a string
# 

# Capitalizes initial character of argument string(s) passed.
capitalize_ichar () 
{
    string0="$@" # Accepts multiple arguments.

    firstchar=${string0:0:1} # First character. 
    string1=${string0:1} # Rest of string(s).

    # Capitalize first character.
    FirstChar=`echo "$firstchar" | tr a-z A-Z` 
    
    echo "$FirstChar$string1" # Output to stdout. 
} 
