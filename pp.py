import numpy as np
from tqdm import tqdm
import os.path

for idx in range(601,701):
    file_name = "data/230419/230419_n%d_"%(idx)

    job_arr_start = 0
    job_arr_end = 10
    job_arr_step = 1
    job_arr_l = np.arange(job_arr_start,job_arr_end,job_arr_step)

    cnt = 0
    for job_id in tqdm(job_arr_l):
        job_name = file_name + str(job_id)
        if os.path.isfile(job_name+"_cmi.csv") == False:
            print(idx, job_id)
            continue

        if cnt == 0:
            cmi_raw = np.loadtxt(job_name+"_cmi.csv",skiprows=1,delimiter=",")
            mi_raw = np.loadtxt(job_name+"_mi.csv",skiprows=1,delimiter=",")
            ci_raw =  np.loadtxt(job_name+"_ci.csv",skiprows=1,delimiter=",")
            n_meas_l = cmi_raw[:,0]
            cmi_l = cmi_raw[:,1]
            mi_l = mi_raw[:,1]
            ci_l = ci_raw[:,1]

        else:
            cmi_raw = np.loadtxt(job_name+"_cmi.csv",skiprows=1,delimiter=",")
            mi_raw = np.loadtxt(job_name+"_mi.csv",skiprows=1,delimiter=",")
            ci_raw =  np.loadtxt(job_name+"_ci.csv",skiprows=1,delimiter=",")
            cmi_l = cmi_l + cmi_raw[:,1]
            mi_l = mi_l + mi_raw[:,1]
            ci_l = ci_l + ci_raw[:,1]

        cnt = cnt + 1

    cmi_l = cmi_l / cnt
    mi_l = mi_l / cnt
    ci_l = ci_l / cnt

    if cnt > 0:
        np.savez(file_name+"pp.npz",n_meas_l=n_meas_l,cmi_l=cmi_l,mi_l=mi_l,ci_l=ci_l)