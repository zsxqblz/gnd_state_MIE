#!/bin/bash
#SBATCH --job-name=xzzx
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --time=23:59:00          # total run time limit (HH:MM:SS)
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=yz4281@princeton.edu
#SBATCH --array=0-9

let i=$1
let dx=20*i
let dy=20*i
let yi=10*i
let offset=10*i
let str_length=10*i
let mode=1
let n_meas_step=8*i*i
let meas_basis=2
let nsim=100

let id=65+i
let date=230416

#                    dx  dy   yi offset str_length mode n_meas_step meas_basis  nsim file_name
# julia run_cluster.jl 10  100   50 0      10         0    2           2           1000 data/230416/230416_n30_$SLURM_ARRAY_TASK_ID
julia run_cluster.jl $dx $dy $yi $offset $str_length $mode $n_meas_step $meas_basis  $nsim data/${date}/${date}_n${id}_$SLURM_ARRAY_TASK_ID