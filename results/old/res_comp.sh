#!/bin/bash

file1="sing/$1*"
file2="sing/$2*"
cofile1="coscheds/cosched_$1*_$2*"
cofile2="coscheds/cosched_$2*_$1*"

if [ -f $cofile1 ]
then
	cofile=$cofile1
else
	cofile=$cofile2
fi

echo -e "file1: $file1, file2: $file2, cofile: $cofile"
kate $file1 $file2 $cofile &
