include("dependencies.jl")
include("sim.jl")
include("toric.jl")
include("xzzx.jl")
include("cluster.jl")

# toric
let
    run(`clear`)
    idx_start = 0
    for idx = 1:5
        dx = 10
        dy = 10+4*idx
        reg = genToricCode(dx,dy)
        allArr = collect(1:2*dx*dy)

        AsitesArr = genToricSqrIdx(1,10,1,1,dx,dy)
        CsitesArr = genToricSqrIdx(1,10,5,5,dx,dy)

        # yi = 5
        # AsitesArr = genToricDiagIdx(1,yi,yi,dx,dy,true)
        # CsitesArr = genToricDiagIdx(1+idx,yi+idx,yi,dx,dy,false)
        
        # yi = 3
        # AsitesArr = genToricDiagIdx(1,yi,yi,dx,dy,true)
        # dlength = yi+idx
        # if dlength > min(dx,dy)
        #     dlength = 2*min(dx,dy) - dlength
        # end
        # CsitesArr = genToricDiagIdx(1+idx,yi+idx,dlength,dx,dy,false)

        BsitesArr = diffIdx(allArr,AsitesArr)
        BsitesArr = diffIdx(BsitesArr,CsitesArr)

        n_meas_start = length(BsitesArr) % 4
        n_meas_end = length(BsitesArr)
        n_meas_step = 4
        n_meas_l = range(n_meas_start,n_meas_end,step=n_meas_step)
        n_meas_length = length(n_meas_l)

        cmi_l = zeros(Float64,n_meas_length)
        mi_l = zeros(Float64,n_meas_length)
        ci_l = zeros(Float64,n_meas_length)
        nsim = 1000
        @showprogress for (i,n_meas) in enumerate(n_meas_l)
            for j in 1:nsim
                treg = deepcopy(reg)
                randYMeasB(treg,BsitesArr,n_meas)
                cmi_l[i] = cmi_l[i] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
                mi_l[i] = mi_l[i] + mi(treg,AsitesArr,CsitesArr)
                ci_l[i] = ci_l[i] + ci(treg,AsitesArr,CsitesArr)
            end
        end

        cmi_l = cmi_l./nsim
        mi_l = mi_l./nsim
        ci_l = ci_l./nsim
        save1DData(n_meas_l,cmi_l,string("data/230416/230416_",idx_start+idx,"_cmi.csv"))
        save1DData(n_meas_l,mi_l,string("data/230416/230416_",idx_start+idx,"_mi.csv"))
        save1DData(n_meas_l,ci_l,string("data/230416/230416_",idx_start+idx,"_ci.csv"))
    end
end

# cluster
let 
    idx_start = 273
    for idx = 1:10
        dx = 20
        dy = 20
        reg = genCluster(dx,dy)
        allArr = collect(1:dx*dy)

        # AsitesArr = genClusterSqrIdx(1,10,1,1,dx,dy)
        # CsitesArr = genClusterSqrIdx(1,10,2+idx,2+idx,dx,dy) 

        yi = 10
        AsitesArr = genClusterDiagIdx(1,yi,yi,dx,dy,true)
        CsitesArr = genClusterDiagIdx(1+idx,yi+idx,yi,dx,dy,false)

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
                randYMeasB(treg,BsitesArr,n_meas)
                cmi_l[i] = cmi_l[i] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
                mi_l[i] = mi_l[i] + mi(treg,AsitesArr,CsitesArr)
            end
        end

        cmi_l = cmi_l./nsim
        mi_l = mi_l./nsim
        save1DData(n_meas_l,cmi_l,string("data/230405/230405_",idx_start+idx,".csv"))
        save1DData(n_meas_l,mi_l,string("data/230405/230405_",idx_start+idx,"_mi.csv"))
    end
end


# xzzx
let
    idx_start = 245
    for idx = 1:5
        dx = 10
        dy = 10
        reg = genXZZXCode(dx,dy)
        allArr = collect(1:2*dx*dy)

        # AsitesArr = genXZZXSqrIdx(1,10,1,1,dx,dy)
        # CsitesArr = genXZZXSqrIdx(1,10,1+idx,1+idx,dx,dy)

        yi = 5
        AsitesArr = genXZZXDiagIdx(1,yi,yi,dx,dy,true)
        CsitesArr = genXZZXDiagIdx(1+idx,yi+idx,yi,dx,dy,false)

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
        save1DData(n_meas_l,cmi_l,string("data/230405/230405_",idx_start+idx,".csv"))
        save1DData(n_meas_l,mi_l,string("data/230405/230405_",idx_start+idx,"_mi.csv"))
    end
end

let 
    reg = genXZZXCode(3,3)
end

let 
    6 % 3
end