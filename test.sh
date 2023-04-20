#!/bin/bash

for i in {1..2..1}
do
    for j in {1..5..1}
    do
    echo $i $j
    done
done

# let i=$1
# let dx=20*i
# let dy=20*i
# let yi=10*i
# let offset=10*i
# let str_length=10*i
# let mode=1
# let n_meas_step=4*i*i
# let meas_basis=2
# let nsim=1

# echo data/230416/230416_n$i

# julia run_cluster.jl $dx $dy $yi $offset $str_length $mode $n_meas_step $meas_basis  $nsim data/230416/230416_test