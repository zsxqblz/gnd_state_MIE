#!/bin/bash
#SBATCH --job-name=n20
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --time=23:59:00          # total run time limit (HH:MM:SS)
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --array=0-49
#SBATCH --mail-user=yz4281@princeton.edu

#                  dx  dy   yi offset str_length mode n_meas_step  nsim file_name
julia run_toric.jl 100 100  50 50     50        0     200          20   data/230416/230416_n20_$SLURM_ARRAY_TASK_ID