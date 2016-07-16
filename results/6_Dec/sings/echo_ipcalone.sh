#!/bin/bash

name=`cat results.txt | grep $1 | awk {'print $1'}`
ipc_alone=`cat results.txt | grep $1 | awk {'print $15'}`
#echo $ipc_alone
echo $name
echo "$ipc_alone * 1000" | bc -l
