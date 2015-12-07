#!/bin/bash
# syndiazontai ana dyo ta benchmarks kai paragontai
# gia kathe dyada ena conf file poy ta topothetei sto idio gang
# Xreiazetai ena config file (commands.config) to opoio orizei enan
# pinaka PROGS me NO_OF_PROGS entoles, kathws kai enan pinaka CORES
# me tous pyrhnes pou zhta kathe benchmark.

#usage="Usage: $0 <'sched' | \'cosched\'> <config dir>"

usage="Usage: $0 <sched | cosched> <config dir>" 

CONFIG="./comms.conf"
if [ $# -ne 2 ]
then
	echo $usage
	exit
fi

if [ ! -f $CONFIG ]
then
	echo -e "$0: Configuration file missing."
	exit
fi

. $CONFIG

func=$1
conf_dir=$2

for i in `seq 0 $NO_OF_PROGS`
do
	NAMES[$i]=`echo ${PROGS[$i]} | awk {'print $1'} | awk -F "/" {'print $NF'}`
#	echo ${NAMES[$i]}
done

function mk_uns {
	for i in `seq 0 $NO_OF_PROGS`
	do
		echo "Making config file for ${NAMES[$i]}"
		conf_name=${conf_dir}"/"${NAMES[$i]}".txt"
		echo -e "#cores\tgang\tpos\tprint\ttime\tcommand" > $conf_name
		echo -e "${CORES[$t]}\t1\t1\t0\t0\t${PROGS[$i]}" >> $conf_name
	done

}

function mk_pairs {
	for i in `seq 0 $NO_OF_PROGS`
	do
		for j in `seq $i $NO_OF_PROGS`
		do
			if [ $i -ne $j ]
			then
				conf_name=${conf_dir}"/"${NAMES[$i]}"_"${NAMES[$j]}".txt"
				echo "Making config file for ${NAMES[$i]} and ${NAMES[$j]}"
				echo -e "#cores\tgang\tpos\tprint\ttime\tcommand" > $conf_name
				echo -e "${CORES[$i]}\t1\t1\t0\t0\t${PROGS[$i]}" >> $conf_name
				echo -e "${CORES[$j]}\t1\t2\t0\t0\t${PROGS[$j]}" >> $conf_name
			fi
		done
	done
}

if [ $func == "sched" ]
then
	mk_uns
else
	if [ $func == "cosched" ]
	then
		mk_pairs
	else
		echo $usage
	fi
fi

