#!/bin/bash

base=$1

cd $base
for i in `cat ../../../confFiles/hitmap/commands.txt | awk {'print $1'} | awk -F "/" {'print $NF'}`
do
	cat ${base}_$i.txt_finisheds.out | awk -F "$" {'print $2 "==> " $3'}
	echo -e; echo -e
done
