#!/bin/bash

for i in {1..11}
do
	read conf_name
	conf_name="confs/"$conf_name
	echo -e "#cores\tgang\tpos\tprint\ttime\tcommand" > $conf_name
	read line
	command=`cat ./comms | grep $line | awk -F "\"" {'print $2'}`
	echo -e "4\t1\t1\t0\t0\t$command" >> $conf_name
	
	read line
	command=`cat ./comms | grep $line | awk -F "\"" {'print $2'}`
	echo -e "4\t1\t2\t0\t0\t$command" >> $conf_name
	
	read line
	command=`cat ./comms | grep $line | awk -F "\"" {'print $2'}`
	echo -e "4\t2\t1\t0\t0\t$command" >> $conf_name
	
	read line
	command=`cat ./comms | grep $line | awk -F "\"" {'print $2'}`
	echo -e "4\t2\t2\t0\t0\t$command" >> $conf_name
	
	read line
done < classes.txt

