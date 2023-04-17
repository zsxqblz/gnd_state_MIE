include("dependencies.jl")
include("sim.jl")
include("toric.jl")
include("xzzx.jl")
include("cluster.jl")

# toric
let
    idx_start = 110
    offset_arr = [2,4,6,8,10]
    for (j,offest) in enumerate(offset_arr)
        for idx = 1:5
            dx = 15
            dy = 12
            reg = genToricCode(dx,dy)
            allArr = collect(1:2*dx*dy)

            AsitesArr = genToricSqrIdx(1,offest,1,1,dx,dy)
            CsitesArr = genToricSqrIdx(1,offest,2+idx,2+idx,dx,dy)

            # yi = 5
            # AsitesArr = genToricDiagIdx(1,yi,yi,dx,dy,true)
            # CsitesArr = genToricDiagIdx(1+idx,yi+idx,yi,dx,dy,false)

            BsitesArr = diffIdx(allArr,AsitesArr)
            BsitesArr = diffIdx(BsitesArr,CsitesArr)

            n_meas_start = length(BsitesArr) % 4
            n_meas_end = length(BsitesArr)
            n_meas_step = 4
            n_meas_l = range(n_meas_start,n_meas_end,step=n_meas_step)
            n_meas_length = length(n_meas_l)

            cmi_l = zeros(Float64,n_meas_length)
            mi_l = zeros(Float64,n_meas_length)
            nsim = 100
            @showprogress for (i,n_meas) in enumerate(n_meas_l)
                for j in 1:nsim
                    treg = deepcopy(reg)
                    randYMeasB(treg,BsitesArr,n_meas)
                    cmi_l[i] = cmi_l[i] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
                    mi_l[i] = mi_l[i] + mi(treg,AsitesArr,CsitesArr)
                end
            end

            cmi_l = cmi_l./nsim
            mi_l = mi_l./nsim
            save1DData(n_meas_l,cmi_l,string("data/230410/230410_",idx_start+idx+(j-1)*5,".csv"))
            save1DData(n_meas_l,mi_l,string("data/230410/230410_",idx_start+idx+(j-1)*5,"_mi.csv"))
        end
    end
end

# cluster
let
    idx_start = 115
    offset_arr = [1,2,4,6,8,10]
    for (j,offest) in enumerate(offset_arr)
        for idx = 1:5
            dx = 10
            dy = 10
            reg = genCluster(dx,dy)
            allArr = collect(1:dx*dy)
            AsitesArr = genClusterSqrIdx(1,offest,1,1,dx,dy)
            CsitesArr = genClusterSqrIdx(1,offest,1+idx,1+idx,dx,dy)
            BsitesArr = diffIdx(allArr,AsitesArr)
            BsitesArr = diffIdx(BsitesArr,CsitesArr)

            n_meas_start = length(BsitesArr) % 2
            n_meas_end = length(BsitesArr)
            n_meas_step = 2
            n_meas_l = range(n_meas_start,n_meas_end,step=n_meas_step)
            n_meas_length = length(n_meas_l)

            cmi_l = zeros(Float64,n_meas_length)
            mi_l = zeros(Float64,n_meas_length)
            nsim = 100
            @showprogress for (i,n_meas) in enumerate(n_meas_l)
                for j in 1:nsim
                    treg = deepcopy(reg)
                    randXMeasB(treg,BsitesArr,n_meas)
                    cmi_l[i] = cmi_l[i] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
                    mi_l[i] = mi_l[i] + mi(treg,AsitesArr,CsitesArr)
                end
            end

            cmi_l = cmi_l./nsim
            mi_l = mi_l./nsim
            save1DData(n_meas_l,cmi_l,string("data/230405/230405_",idx_start+idx+(j-1)*5,".csv"))
            save1DData(n_meas_l,mi_l,string("data/230405/230405_",idx_start+idx+(j-1)*5,"_mi.csv"))
        end
    end
end


# xzzx
let
    idx_start = 235
    offset_arr = [1,2,4,6,8,10]
    for (j,offest) in enumerate(offset_arr)
        for idx = 1:5
            dx = 10
            dy = 10
            reg = genXZZXCode(dx,dy)
            allArr = collect(1:2*dx*dy)

            # AsitesArr = genXZZXSqrIdx(1,offest,1,1,dx,dy)
            # CsitesArr = genXZZXSqrIdx(1,offest,1+idx,1+idx,dx,dy)

            yi = 5
            AsitesArr = genToricDiagIdx(1,yi,yi,dx,dy,true)
            CsitesArr = genToricDiagIdx(1+idx,yi+idx,yi,dx,dy,false)

            BsitesArr = diffIdx(allArr,AsitesArr)
            BsitesArr = diffIdx(BsitesArr,CsitesArr)

            n_meas_start = length(BsitesArr) % 4
            n_meas_end = length(BsitesArr)
            n_meas_step = 4
            n_meas_l = range(n_meas_start,n_meas_end,step=n_meas_step)
            n_meas_length = length(n_meas_l)

            cmi_l = zeros(Float64,n_meas_length)
            mi_l = zeros(Float64,n_meas_length)
            nsim = 100
            @showprogress for (i,n_meas) in enumerate(n_meas_l)
                for j in 1:nsim
                    treg = deepcopy(reg)
                    randYMeasB(treg,BsitesArr,n_meas)
                    cmi_l[i] = cmi_l[i] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
                    mi_l[i] = mi_l[i] + mi(treg,AsitesArr,CsitesArr)
                end
            end

            cmi_l = cmi_l./nsim
            mi_l = mi_l./nsim
            save1DData(n_meas_l,cmi_l,string("data/230405/230405_",idx_start+idx+(j-1)*5,".csv"))
            save1DData(n_meas_l,mi_l,string("data/230405/230405_",idx_start+idx+(j-1)*5,"_mi.csv"))
        end
    end
end

let 
    reg = genXZZXCode(3,3)
end

let 
    6 % 3
end