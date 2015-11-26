#!/bin/bash

bw=45000000
l_limit=`expr $bw / 2`
c_limit=`expr $bw / 10`

echo -e "bandwidth: $bw"
echo -e "l_limit: $l_limit"
echo -e "c_limit: $c_limit"

function count_lines {
	count=`wc -l $1 | awk {'print $1'}`
	count=`expr $count - 1`
}

function sum {
	sum=`tail -n+2 gemm_STANDARD.txt.out | awk -F '$' {'print $8'} | awk '{ sum += $1 } END { print sum }'`	
}

count_lines $1
sum $1
bbw=`expr $sum / $count`
echo -e "bw used by bench: $bbw"

	
