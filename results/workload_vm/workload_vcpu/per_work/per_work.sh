#!/bin/bash

avg(){
	average=0
	local i=0
	for i in $@
	do
		average=`echo -e "scale=2; ($average + $i)" | bc -l`
	done
	average=`echo -e "scale=2; ($average / $#)" | bc -l`
}

for work in */; do
	cd $work;
	echo $work
	for sched in */; do
		echo $sched
		for i in {1..8}; do
			bench=`ls $sched/$i*`
			# echo -e "$i - $bench"
			av=`grep "real" $sched/$i*/$bench | awk {'print $2'}`
			avg $av
			echo -e "\t$i-$bench\t$average"
		done
	done > test.txt
	cd ..
done
