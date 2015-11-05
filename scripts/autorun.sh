#!/bin/bash

if [ "$#" -ne "2" ]
then
	echo -e "Usage: $0 <conf_dir> <result_dir>"
else
	exec 2>>./kpjim_stderr
	conf_dir=$1
	result_dir=$2
	for i in $conf_dir/*.txt
	do
		name=`echo $i | awk -F "/" {'print $NF'}`
		echo -e "Running scaff for $name"
		./cleanup.sh
		./cleanup.sh
		./aff-executor $i results 0,1,2,3,4,5,6,7 llcm
		cp results/counters-out $result_dir/${name}.out
		mv $i $conf_dir/.$name
	done
fi
