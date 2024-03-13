#!/bin/bash
PREFIX="${1:-NOT_SET}"
ip_regex1="^(([1|2]?[0-9])?[0-9]\.)(([1|2]?[0-9])?[0-9])$"
ip_regex2="^(([1|2]?[0-9])?[0-9]\.)(([1|2]?[0-9])?[0-9]\.)(([1|2]?[0-9])?[0-9])$"
ip_regex3="^(([1|2]?[0-9])?[0-9]\.){3}([1|2]?[0-9])?[0-9]$"

if [[ "$PREFIX" =~ $ip_regex1 ]]; then
    for SUBNET in {1..255}
	do
	    for HOST in {1..255}
		do
		    ping -c 2 -W 1 "${PREFIX}.${SUBNET}.${HOST}"  2> /dev/null 
            if [[ $? == 0 ]]; then
                 echo "${PREFIX}.${SUBNET}.${HOST}" ' OK' >> ping_log.txt
            fi
	    done
    done
    
elif [[ "$PREFIX" =~ $ip_regex2 ]]; then
    for HOST in {1..255}
	do
		ping -c 2 -W 1 "${PREFIX}.${HOST}" 2> /dev/null
        if [[ $? == 0 ]]; then
            echo "${PREFIX}.${HOST}" ' OK'  >> ping_log.txt
        fi
	done
    
elif [[ "$PREFIX" =~ $ip_regex3 ]]; then
    parspref=$(echo "$PREFIX" | grep -Eo '^(([1|2]?[0-9])?[0-9]\.){2}(([1|2]?[0-9])?[0-9])')
    parshost=$(echo "$PREFIX" | grep -Eo '(([1|2]?[0-9])?[0-9])$') 
    for HOST in $(seq "$parshost" 1 255)
	do
		ping -c 2 -W 1 "${parspref}.${HOST}" 2> /dev/null
        if [[ $? == 0 ]]; then
            echo "${parspref}.${HOST}" ' OK'  >> ping_log.txt
        fi
	done
else
	echo "PREFIX example '192.168' as first positional argument"; exit 1;
fi
