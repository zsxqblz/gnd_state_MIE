#!/bin/bash

for i in {1..5..1}
do
  sbatch run_xzzx.sh $i
done