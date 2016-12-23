#!/bin/bash



run_print(){
	base=$1
	final=$base
	
	cd $base
	for i in `cat ../../../confFiles/hitmap/commands.txt | awk {'print $1'} | awk -F "/" {'print $NF'}`
	do
		comms="$comms\t$i"
		time=`cat ${base}_$i.txt_finisheds.out | grep ${base} | awk -F "$" {'print $3'}`
		time=`echo -e "$i\t$time" | grep $i | awk {'print $2'}`
		final="$final\t$time"
	done
# 	echo -e $comms
	echo -e $final
	cd ..
}

# for i in `ls`
for i in `cat ../../confFiles/hitmap/commands.txt | awk {'print $1'} | awk -F "/" {'print $NF'}`
do
	if [ -d $i ]
	then
		run_print $i >> all.txt
	fi
done

# run_print 2mm_STANDARD
