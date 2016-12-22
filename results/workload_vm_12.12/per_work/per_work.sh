#!/bin/bash

avg(){
	average=0
	for i in $@
	do
		average=$(($average + $i))
	done
	average=`echo -e "scale=2; ($average / $#)" | bc -l`
}

avg $@
echo -e $average
