#!/bin/bash

# for i in {1..5..1}
# do
#   sbatch run_toric.sh $i 0
# done

for i in {1..5..1}
do
    for j in {1..5..1}
    do
    sbatch run_toric.sh $i $j
    done
done