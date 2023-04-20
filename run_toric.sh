#!/bin/bash
#SBATCH --job-name=toric
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --time=23:59:00          # total run time limit (HH:MM:SS)
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=fail          # send email when job ends
#SBATCH --mail-user=yz4281@princeton.edu
#SBATCH --array=0-0

let i=$1
let j=$2
# let dx=20
let dx=20*i
let dy=20
# let dy=20*i
let yi=10
let offset=5*i
let str_length=4*i*j
let mode=0
let n_meas_step=8*i
let meas_basis=2
let nsim=500

# let id=0+i
let id=775+5*j-5+i
let date=230419

julia run_toric.jl $dx $dy $yi $offset $str_length $mode $n_meas_step $meas_basis  $nsim data/${date}/${date}_n${id}_$SLURM_ARRAY_TASK_ID