#!/bin/bash

# for i in {1..5..1}
# do
#   sbatch run_cluster.sh $i
# done

for i in {1..5..1}
do
    for j in {1..5..1}
    do
    sbatch run_cluster.sh $i $j
    done
done