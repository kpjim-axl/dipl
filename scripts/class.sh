#!/bin/bash

B_max=204976587
N_FILE=n_commands.conf
C_FILE=c_commands.conf
LC_FILE=lc_commands.conf
L_FILE=l_commands.conf
COMM_FILE=commands.config
COMM_FILE=comms
CONF_DIR=./confs

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

# class: find out the class of a bench
# args:	$1: results_file
function class {
	read_stats $1
	calc_stats
	local bench=`echo $1 | awk -F "/" {'print $NF'} | awk -F "." {'print $1'}`
	# echo -e "$bench:"
	# echo -e "\taverage bw: $bw_avg"
	# echo -e "\taverage l2_reuse: $cr_1"
	# echo -e "\taverage l3_reuse: $cr_2"
	# echo -e "\taverage IPC: $ipc_avg"
	
	# Memory Link Utilization
	local comp=`echo -e "$bw_avg > $a" | bc -l`
	if [ $comp -eq 1 ]
	then
		echo -e "$bench: L"
		# do whatever
		# ...
		NO_OF_PROGS=`cat $CONF_DIR/$L_FILE | grep NO_OF_PROGS | awk -F "=" {'print $2'}`
		N_OF_PROGS=$(($NO_OF_PROGS + 1))
		awk '/NO_OF_PROGS/{gsub('$NO_OF_PROGS','$N_OF_PROGS')}; {print > "'$CONF_DIR'/'$L_FILE'"}' $CONF_DIR/$L_FILE
		echo -e "l_progs[$NO_OF_PROGS]=`cat $COMM_FILE | grep $bench`" >> $CONF_DIR/$L_FILE
# 		exit
		return
	fi

	local comp=`echo -e "$bw_avg > $b" | bc -l`
	if [ $comp -eq 1 ]
	then
		echo -e "$bench: LC"
		# do whatever
		# ...
		NO_OF_PROGS=`cat $CONF_DIR/$LC_FILE | grep NO_OF_PROGS | awk -F "=" {'print $2'}`
		N_OF_PROGS=$(($NO_OF_PROGS + 1))
		awk '/NO_OF_PROGS/{gsub('$NO_OF_PROGS','$N_OF_PROGS')}; {print > "'$CONF_DIR'/'$LC_FILE'"}' $CONF_DIR/$LC_FILE
		echo -e "lc_progs[$NO_OF_PROGS]=`cat $COMM_FILE | grep $bench`" >> $CONF_DIR/$LC_FILE
# 		exit
		return
	fi

	# Cache Links Utilization
	# den 3erw pws na vrw ta bandwidths opote paw kateutheian aristera
	# Reuse Location...
	local comp=`echo -e "$cr_1 < $cr_2" | bc -l`
	if [ $comp -eq 1 ]
	then
		echo -e "$bench: C"
		# do whatever
		# ...
		NO_OF_PROGS=`cat $CONF_DIR/$C_FILE | grep NO_OF_PROGS | awk -F "=" {'print $2'}`
		N_OF_PROGS=$(($NO_OF_PROGS + 1))
		awk '/NO_OF_PROGS/{gsub('$NO_OF_PROGS','$N_OF_PROGS')}; {print > "'$CONF_DIR'/'$C_FILE'"}' $CONF_DIR/$C_FILE
		echo -e "c_progs[$NO_OF_PROGS]=`cat $COMM_FILE | grep $bench`" >> $CONF_DIR/$C_FILE
	else
		echo -e "$bench: N"
		# do whatever
		# ...
		NO_OF_PROGS=`cat $CONF_DIR/$N_FILE | grep NO_OF_PROGS | awk -F "=" {'print $2'}`
		N_OF_PROGS=$(($NO_OF_PROGS + 1))
		awk '/NO_OF_PROGS/{gsub('$NO_OF_PROGS','$N_OF_PROGS')}; {print > "'$CONF_DIR'/'$N_FILE'"}' $CONF_DIR/$N_FILE
		echo -e "n_progs[$NO_OF_PROGS]=`cat $COMM_FILE | grep $bench`" >> $CONF_DIR/$N_FILE
	fi
}

# main
# args:
# 	v1:	$1: results-file
# 	v2:	$1: results-directory
if [ ! -f $COMM_FILE ]
then
	echo -e "$COMM_FILE: No such file or directory"
# 	exit
fi

RES_FILE=$1
# if [ ! -f $RES_FILE ]
# then
# 	echo -e "$RES_FILE: No such file or directory"
# 	exit
# fi
RES_DIR=$1
echo "NO_OF_PROGS=0" > $CONF_DIR/$L_FILE
echo "NO_OF_PROGS=0" > $CONF_DIR/$C_FILE
echo "NO_OF_PROGS=0" > $CONF_DIR/$LC_FILE
echo "NO_OF_PROGS=0" > $CONF_DIR/$N_FILE
for i in $RES_DIR/*
do
	bench=`echo $i | awk -F "/" {'print $NF'} | awk -F "." {'print $1'}`
	class $i
# 	cat $COMM_FILE | grep $bench >> $CONF_DIR/$CLASS_FILE
done
