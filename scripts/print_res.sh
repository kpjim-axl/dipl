#!/bin/bash

function calc_bw_avg {
	sum=`tail -n+2 $1 | awk -F '$' {'print $8'} | awk '{ sum += $1 } END { print sum }'`
	count=`wc -l $1 | awk {'print $1'}`
	count=`expr $count - 1`
	bw_avg=`expr $sum / $count`
}

function calc_mem {
	count=`wc -l $1 | awk {'print $1'}`
	count=`expr $count - 1`
	l2_sum=`tail -n+2 $1 | awk -F '$' {'print $19'} | awk '{ sum += $1 } END { print sum }'`
	l2_sum=`tail -n+2 $1 | awk -F '$' {'print $19'} | awk '{ sum += $1 } END { print sum }'`
	l2_reuse=`echo $l2_sum/$count | bc`

	l3_sum=`tail -n+2 $1 | awk -F '$' {'print $20'} | awk '{ sum += $1 } END { print sum }'`
	l3_reuse=`expr $l3_sum / $count`
	l3_reuse=`echo $l3_sum/$count | bc`
}

for file in `ls $1`
do
	if [ -f $file ]
	then
		calc_bw_avg $file
		calc_mem $file
		echo -e "$file:\n\tbw_avg: $bw_avg, l2_reuse: $l2_reuse, l3_reuse: $l3_reuse\n"
	fi
done
