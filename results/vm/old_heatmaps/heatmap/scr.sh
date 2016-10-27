#!/bin/bash

cd $1

awk '/STARTING/{flag=1;next} /FINISHED/{flag=0} flag {print}' fin_bench_all > all
mkdir res; mkdir time
for i in `cat fin_bench_all | grep STARTING | awk '{print $2}'` ; do cat all | grep -A 3 $i > res/$i; done

for i in `cat fin_bench_all | grep STARTING | awk '{print $2}'` ; do cat res/$i | grep real | awk {'print $2'} > time/$i; done
cd ..
