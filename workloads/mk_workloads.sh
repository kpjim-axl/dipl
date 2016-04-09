#!/bin/bash

L_COMMS=(
"./bin/jacLR results/jaclr-out 50"
"./bin/uniform/stream_d0"
)

LC_COMMS=(
"./bin/uniform/ft.A"
"./bin/uniform/gemver_STANDARD dummy.out 50"
"./bin/uniform/gesummv_STANDARD dummy.out 70"
"./bin/uniform/mvt_STANDARD dummy.out 70"
"./bin/uniform/syr2k_STANDARD dummy.out 20"
"./bin/uniform/trisolv_STANDARD dummy.out 90"
"./bin/uniform/trmm_STANDARD dummy.out 70"
)

C_COMMS=(
"./bin/uniform/2mm_STANDARD dummy.out 2"
"./bin/uniform/3mm_STANDARD dummy.out 2"
"./bin/uniform/cholesky_STANDARD dummy.out 100"
"./bin/uniform/durbin_STANDARD dummy.out 10"
"./bin/uniform/ep.A.g"
"./bin/uniform/gemm_STANDARD dummy.out 5"
"./bin/uniform/gramschmidt_STANDARD dummy.out 10"
"./bin/uniform/syrk_STANDARD dummy.out 40"
)

N_COMMS=(
"./bin/uniform/doitgen_STANDARD dummy.out 100"
)

echo -e ${C_COMMS[1]}