#!/bin/bash
# syndiazontai ana dyo ta benchmarks kai paragontai
# gia kathe dyada ena conf file poy ta topothetei sto idio gang

if [ $# -ne 1 ]
then
	echo "Usage: $0 <config dir>"
	exit
fi

conf_dir=$1

# commands
PROGS[0]="./bin/jacLR results/jaclr-out 50"
PROGS[1]="./bin/blackscholes 4 bin/in_10M.txt bsdummy"
PROGS[2]="./bin/uniform/stream_d0"
PROGS[3]="./bin/uniform/ep.A.g"
PROGS[4]="./bin/uniform/2mm_STANDARD dummy.out 2"
PROGS[5]="./bin/uniform/3mm_STANDARD dummy.out 2"
PROGS[6]="./bin/uniform/cholesky_STANDARD dummy.out 100"
PROGS[7]="./bin/uniform/doitgen_STANDARD dummy.out 100"
PROGS[8]="./bin/uniform/gemm_STANDARD dummy.out 5"
PROGS[9]="./bin/uniform/gemver_STANDARD dummy.out 50"
PROGS[10]="./bin/uniform/gesummv_STANDARD dummy.out 70"
PROGS[11]="./bin/uniform/mvt_STANDARD dummy.out 70"
PROGS[12]="./bin/uniform/syr2k_STANDARD dummy.out 20"
PROGS[13]="./bin/uniform/syrk_STANDARD dummy.out 40"
PROGS[14]="./bin/uniform/trisolv_STANDARD dummy.out 90"
PROGS[15]="./bin/uniform/trmm_STANDARD dummy.out 70"
PROGS[16]="./bin/uniform/durbin_STANDARD dummy.out 10"
PROGS[17]="./bin/uniform/gramschmidt_STANDARD dummy.out 10"
PROGS[18]="./bin/uniform/ft.A"

# random values..
CORES=(	4 4 4 4
	4 4 4 4
	4 4 4 4
	4 4 4 4
	4 4 4 4
	)

for i in `seq 0 18`
do
	NAMES[$i]=`echo ${PROGS[$i]} | awk {'print $1'} | awk -F "/" {'print $NF'}`
	echo ${NAMES[$i]}
done

function mk_pairs {
	for i in `seq 0 18`
	do
		for j in `seq $i 18`
		do
			if [ $i -ne $j ]
			then
				conf_name=${conf_dir}"/cosched_"${NAMES[$i]}"_"${NAMES[$j]}".txt"
				echo "Making config file for ${NAMES[$i]} and ${NAMES[$j]}"
				echo -e "#cores\tgang\tpos\tprint\ttime\tcommand" > $conf_name
				echo -e "${CORES[$i]}\t1\t1\t0\t0\t${PROGS[$i]}" >> $conf_name
				echo -e "${CORES[$j]}\t1\t2\t0\t0\t${PROGS[$j]}" >> $conf_name
			fi
		done
	done
}

mk_pairs
