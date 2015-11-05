#!/bin/bash

if [ "$#" -ne "2" ]
then
	echo -e "Usage: $0 <coscheds> <command string>"
else
	if [ "$1" -eq "1" ]
	then
		one="_one"
	else
		one=
	fi
	name=`echo $2 | awk {'print $1'} | awk -F "/" {'print $NF'}`${one}.txt
	echo $name
	echo -e "#cores  gang    pos     print   time    command" > $name
	for ((i=0; i<$1; i++))
	do
		gang=$(expr $(expr $i + 2) / 2)
		pos=$(expr $(expr $i % 2) + 1)
		echo -e "5\t$gang\t$pos\t0\t0\t$2" >> $name
	done
fi
