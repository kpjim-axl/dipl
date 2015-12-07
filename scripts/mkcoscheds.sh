#!/bin/bash
# syndiazontai ana dyo ta benchmarks kai paragontai
# gia kathe dyada ena conf file poy ta topothetei sto idio gang
# Xreiazetai ena config file (commands.config) to opoio orizei enan
# pinaka PROGS me NO_OF_PROGS entoles, kathws kai enan pinaka CORES
# me tous pyrhnes pou zhta kathe benchmark.

#usage="Usage: $0 <'sched' | \'cosched\'> <config dir>"

# usage="Usage: $0 <sched | cosched> <config dir>" 
# 
# CONFIG="./commands.config"
# if [ $# -ne 2 ]
# then
# 	echo $usage
# 	exit
# fi
# 
# if [ ! -f $CONFIG ]
# then
# 	echo -e "$0: Configuration file missing."
# 	exit
# fi
# 
# . $CONFIG
# 
# func=$1
# conf_dir=$2
# 
# for i in `seq 0 $NO_OF_PROGS`
# do
# 	NAMES[$i]=`echo ${PROGS[$i]} | awk {'print $1'} | awk -F "/" {'print $NF'}`
# #	echo ${NAMES[$i]}
# done

function mk_uns {
	for i in `seq 0 $NO_OF_PROGS`
	do
		echo "Making config file for ${NAMES[$i]}"
		conf_name=${conf_dir}"/"${NAMES[$i]}".txt"
		echo -e "#cores\tgang\tpos\tprint\ttime\tcommand" > $conf_name
		echo -e "${CORES[$t]}\t1\t1\t0\t0\t${PROGS[$i]}" >> $conf_name
	done

}

# mk_pairs: ftiaxnei ta conf files. Tou dinoume tis klaseis tis opoies tha syndiasei san orismata (mk_pairs l lc)
# args:	$1: 1 class
# 		$2: 2 class
function mk_pairs {
	local class_1=$1
	local class_2=$2
	local c1_file=$comm_dir"/"$class_1"_commands.conf"
	local c2_file=$comm_dir"/"$class_2"_commands.conf"
	
	local cosch=$class_1"-"$class_2
	if [ ! -d $final/$cosch ]
	then
		mkdir $final/$cosch
	fi
	. $c1_file
	local no_of_progs_1=$NO_OF_PROGS
	. $c2_file
	local no_of_progs_2=$NO_OF_PROGS
	
# 	echo $no_of_progs_1
# 	echo $no_of_progs_2
	for i in `seq 0 $(($no_of_progs_1 - 1))`
	do
		local comm_1=$class_1"_progs[$i]"
		local comm_1=${!comm_1}
		local name_1=`echo $comm_1 | awk '{print $1}' | awk -F "/" '{print $NF}'`
# 		echo -e "name1: $name_1"
		for j in `seq 0 $(($no_of_progs_2 - 1))`
		do
			local comm_2=$class_2"_progs[$j]"
			local comm_2=${!comm_2}
			local name_2=`echo $comm_2 | awk '{print $1}' | awk -F "/" '{print $NF}'`
			local name=$name_1"_"$name_2".txt.out"
			local name2=$name_2"_"$name_1".txt.out"
			echo -e "name: $name"
			echo -e "name2: $name2"
			if [ -f $res_dir/$name ]
			then
				mv $res_dir/$name $final/$cosch/$name_1"_"$name_2".out"
			fi
			if [ -f $res_dir/$name2 ]
			then
				mv $res_dir/$name2 $final/$cosch/$name_2"_"$name_1".out"
			fi
			
		done
	done
# 			conf_name=
# 			conf_name=${conf_dir}"/"
}

function mk_pairs_2 {
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

# main
comm_dir="./confs/"
res_dir=$1
final=$2
mk_pairs l l
mk_pairs l lc
mk_pairs l c
mk_pairs l n
mk_pairs lc lc
mk_pairs lc c
mk_pairs lc n
mk_pairs c c
mk_pairs c n
mk_pairs n n

# if [ $func == "sched" ]
# then
# 	mk_uns
# else
# 	if [ $func == "cosched" ]
# 	then
# 		mk_pairs
# 	else
# 		echo $usage
# 	fi
# fi

