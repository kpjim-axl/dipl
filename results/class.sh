#!/bin/bash

B_max=204976587
# read_stats: read stats from results file.
# bw_avg: average per core bandwidth
# cr_i: i-level cache reuse ratio
# args:	$1: results-file
function read_stats {
	# count: synolo metrhsewn
	local count=`wc -l $1 | awk {'print $1'}`
	local count=`expr $count - 1`

	# bw_sum athroisma per_core_bw
	local bw_sum=`tail -n+2 $1 | awk -F '$' {'print $8'} | awk '{ sum += $1 } END { print sum }'`
	bw_avg=`expr $bw_sum / $count`

	# cr_1 = L2 Reuse
	local l2_reuse_sum=`tail -n+2 $1 | awk -F '$' {'print $19'} | awk '{ sum += $1 } END { print sum }'`
	cr_1=`perl -w -e "printf '%.3f', $l2_reuse_sum/$count"`
	
	# cr_2 = L3 Reuse
	local l3_reuse_sum=`tail -n+2 $1 | awk -F '$' {'print $20'} | awk '{ sum += $1 } END { print sum }'`
	cr_2=`perl -w -e "printf '%.3f', $l3_reuse_sum/$count"`

	# ipc_max: Maximum value of IPC
# 	ipc_max=`tail -n+2 $1 | awk -F '$' {'print $14'} | awk 'BEGIN {max=0} {if (max<$1){max=$1}} END {print max}'`
	ipc_avg=`tail -n+2 $1 | awk -F '$' {'print $14'} | awk 'BEGIN {sum=0} {sum += $1 } END { print sum }'`
	ipc_avg=`perl -w -e "printf '%.3f', $ipc_avg/$count"`
}

# calc_stats: calculate thesholds a,b,c,d,e
function calc_stats {
	a=`echo "0.75 * $B_max" | bc -l`
	b=`echo "0.1 * $B_max" | bc -l`
	c=`echo "0.5 * $B_max" | bc -l`
	d=0.25
#	e=`echo "0.25 * 4" | bc -l`
	e=1
# 	echo -e "thresholds:\n\ta: $a\tb: $b\tc: $c\td: $d\te: $e"
}


# main
read_stats $1
calc_stats
bench=`echo $1 | awk -F "/" {'print $NF'} | awk -F "." {'print $1'}`
# echo -e "$bench:"
# echo -e "\taverage bw: $bw_avg"
# echo -e "\taverage l2_reuse: $cr_1"
# echo -e "\taverage l3_reuse: $cr_2"
# echo -e "\taverage IPC: $ipc_avg"

# Memory Link Utilization
comp=`echo -e "$bw_avg > $a" | bc -l`
if [ $comp -eq 1 ]
then
	class=L
	# do whatever
	# ...
	echo -e "$bench: $class"
	cp $1 classes/$class
	exit
fi

comp=`echo -e "$bw_avg > $b" | bc -l`
if [ $comp -eq 1 ]
then
	class=LC
	# do whatever
	# ...
	echo -e "$bench: $class"
	cp $1 classes/$class
	exit
fi

# Cache Links Utilization
# den 3erw pws na vrw ta bandwidths opote paw kateutheian aristera
# Reuse Location...
comp=`echo -e "$cr_1 < $cr_2" | bc -l`
if [ $comp -eq 1 ]
then
	class=C
	echo -e "$bench: $class"
	cp $1 classes/$class
else
	class=N
	echo -e "$bench: $class"
	cp $1 classes/$class
fi

