include("dependencies.jl")
include("sim.jl")
include("toric.jl")
include("xzzx.jl")
include("cluster.jl")

# toric
let
    idx_start = 0
    for idx = 1:10
        dx = 11
        dy = 11
        reg = genToricCode(dx,dy)
        allArr = collect(1:2*dx*dy)
        AsitesArr = genToricSqrIdx(1,1,1,1,dx,dy)
        CsitesArr = genToricSqrIdx(2+idx,2+idx,2+idx,2+idx,dx,dy)
        BsitesArr = diffIdx(allArr,AsitesArr)
        BsitesArr = diffIdx(BsitesArr,CsitesArr)

        # generate a string connecting A and C
        MsitesArr = Vector{Int64}(undef,0)
        for i = 2:idx
            MsitesArr = vcat(MsitesArr,genToricSqrIdx(i,i,i,i,dx,dy))
        end
        

        n_meas_start = 0
        n_meas_end = length(MsitesArr)
        n_meas_step = 1
        n_meas_l = range(n_meas_start,n_meas_end,step=n_meas_step)
        n_meas_length = length(n_meas_l)

        cmi_l = zeros(Float64,n_meas_length)
        # mi_l = zeros(Float64,n_meas_length)
        nsim = 1000
        @showprogress for (i,n_meas) in enumerate(n_meas_l)
            for j in 1:nsim
                treg = deepcopy(reg)
                randYMeasB(treg,MsitesArr,n_meas)
                cmi_l[i] = cmi_l[i] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
                # mi_l[i] = mi_l[i] + mi(treg,AsitesArr,CsitesArr)
            end
        end

        cmi_l = cmi_l./nsim
        # mi_l = mi_l./nsim
        save1DData(n_meas_l,cmi_l,string("data/230328/230328_",idx_start+idx,".csv"))
        # save1DData(n_meas_l,mi_l,"data/230314/230314_2.csv")
    end
end

# cluster
let 
    idx_start = 10
    for idx = 1:5
        dx = 10
        dy = 10
        reg = genCluster(dx,dy)
        allArr = collect(1:dx*dy)
        AsitesArr = genClusterSqrIdx(1,1,1,1,dx,dy)
        CsitesArr = genClusterSqrIdx(1,1,2+idx,2+idx,dx,dy) 
        BsitesArr = diffIdx(allArr,AsitesArr)
        BsitesArr = diffIdx(BsitesArr,CsitesArr)

        # generate a string connecting A and C
        MsitesArr = Vector{Int64}(undef,0)
        for i = 2:idx
            MsitesArr = vcat(MsitesArr,genClusterSqrIdx(1,1,i,i,dx,dy))
        end
        @show MsitesArr

        n_meas_start = 0
        n_meas_end = length(MsitesArr)
        n_meas_step = 1
        n_meas_l = range(n_meas_start,n_meas_end,step=n_meas_step)
        n_meas_length = length(n_meas_l)

        cmi_l = zeros(Float64,n_meas_length)
        # mi_l = zeros(Float64,n_meas_length)
        nsim = 1000
        @showprogress for (i,n_meas) in enumerate(n_meas_l)
            for j in 1:nsim
                treg = deepcopy(reg)
                randZMeasB(treg,MsitesArr,n_meas)
                cmi_l[i] = cmi_l[i] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
                # mi_l[i] = mi_l[i] + mi(treg,AsitesArr,CsitesArr)
            end
        end

        cmi_l = cmi_l./nsim
        # mi_l = mi_l./nsim
        save1DData(n_meas_l,cmi_l,string("data/230328/230328_",idx_start+idx,".csv"))
        # save1DData(n_meas_l,mi_l,"data/230314/230314_2.csv")
    end
end


# xzzx
let
    idx_start = 60
    for idx = 1:4
        dx = 10
        dy = 10
        reg = genXZZXCode(dx,dy)
        allArr = collect(1:2*dx*dy)
        # AsitesArr = [1,2,3,22]
        # CsitesArr = [151,152,153,172]
        AsitesArr = genXZZXSqrIdx(1,1,1,1,dx,dy)
        CsitesArr = genXZZXSqrIdx(3+idx,3+idx,1+idx,1+idx,dx,dy)
        BsitesArr = diffIdx(allArr,AsitesArr)
        BsitesArr = diffIdx(BsitesArr,CsitesArr)

        n_meas_start = 0
        n_meas_end = 2*dx*dy-4
        n_meas_step = 4
        n_meas_l = range(n_meas_start,n_meas_end,step=n_meas_step)
        n_meas_length = length(n_meas_l)

        cmi_l = zeros(Float64,n_meas_length)
        # mi_l = zeros(Float64,n_meas_length)
        nsim = 1000
        @showprogress for (i,n_meas) in enumerate(n_meas_l)
            for j in 1:nsim
                treg = deepcopy(reg)
                randYMeasB(treg,BsitesArr,n_meas)
                cmi_l[i] = cmi_l[i] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
                # mi_l[i] = mi_l[i] + mi(treg,AsitesArr,CsitesArr)
            end
        end

        cmi_l = cmi_l./nsim
        # mi_l = mi_l./nsim
        save1DData(n_meas_l,cmi_l,string("data/230323/230323_",idx_start+idx,".csv"))
        # save1DData(n_meas_l,mi_l,"data/230314/230314_2.csv")
    end
end

let 
    reg = genToricCode(2,2)
end
