#!/bin/bash
POOL=${1:-vz}

if ! zpool status $POOL > /dev/null 2>&1; then
	echo "Pool $POOL not found."
	exit 1
fi

dsmap=$(mktemp)

zdb $POOL -d -P | awk '{printf "%s %s\n", $5, $2; }' | sed -e 's/,//' | sort > $dsmap

dbufstat.py -r | tail -n+2 | sort -k2n | while read line; do
	set $line
        lobjset=$objset;
        objset=$2
        size=$5
        totsize=$((totsize + $size))
        [ "$objset" != "$lobjset" ] && echo "$objset $totsize" && totsize=0
done | while read line; do
	set $line
        objset=$1
        totsize=$2
        dsname=$(cat $dsmap | grep -P "^$objset " | awk '{print $2;}')
        printf "%-50s %10sM\n" $dsname $(( $totsize / 1024 / 1024))
done

rm -f $dsmap

