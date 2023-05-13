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
    run(`clear`)
    file_name = "data/230501/230501_"
    idx_save = 15
    nsim = 1
    dx = 40
    dy = 40
    hx = trunc(Int, dx/2)
    hy = trunc(Int, dy/2)
    nstr_end = dx
    nstr_step = 3

    nstr_l = collect(1:nstr_step:nstr_end)
    cmi_l = zeros(Float64,length(nstr_l))
    mi_l = zeros(Float64,length(nstr_l))
    ci_l = zeros(Float64,length(nstr_l))
    

    @showprogress for (idx,nstr) in enumerate(nstr_l)
        reg = genCluster(dx,dy)
        allArr = collect(1:dx*dy)
        AsitesArr = genClusterSqrIdx(1,dx,1,1,dx,dy)
        CsitesArr = genClusterSqrIdx(1,dx,hy,hy,dx,dy) 
        BsitesArr = diffIdx(allArr,AsitesArr)
        BsitesArr = diffIdx(BsitesArr,CsitesArr)

        # generate parallel strings connecting A and C
        # MsitesArr = Vector{Int64}(undef,0)
        # for i = 1:nstr_step:nstr
        #     for j = 2:(hy-1)
        #         MsitesArr = vcat(MsitesArr,genClusterSqrIdx(i,i,j,j,dx,dy))
        #     end
        # end
        # # # cut in half
        # hhy = trunc(Int, hy/2)
        # for i = 1:nstr
        #     MsitesArr = vcat(MsitesArr,genClusterSqrIdx(i,i,hhy,hhy,dx,dy))
        # end

        # generate diagonal strings crossing one vertical string
        MsitesArr = Vector{Int64}(undef,0)
        # MsitesArr = vcat(MsitesArr,genClusterSqrIdx(hx,hx,2,hy-1,dx,dy))
        for i = 1:nstr_step:nstr
            for j = 2:(hy-1)
                MsitesArr = vcat(MsitesArr,genClusterSqrIdx(i+j-2,i+j-2,j,j,dx,dy))
                MsitesArr = vcat(MsitesArr,genClusterSqrIdx(i+j-1,i+j-1,j,j,dx,dy))
            end
        end
        
        for i = 1:nsim
            treg = deepcopy(reg)
            randZMeasB(treg,MsitesArr,length(MsitesArr))
            cmi_l[idx] = cmi_l[idx] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
            mi_l[idx] = mi_l[idx] + mi(treg,AsitesArr,CsitesArr)
            ci_l[idx] = ci_l[idx] + ci(treg,AsitesArr,CsitesArr)
        end
    end

    cmi_l = cmi_l./nsim
    mi_l = mi_l./nsim
    ci_l = ci_l./nsim
    save1DData(nstr_l,cmi_l,string(file_name,idx_save,"_cmi.csv"))
    save1DData(nstr_l,mi_l,string(file_name,idx_save,"_mi.csv"))
    save1DData(nstr_l,ci_l,string(file_name,idx_save,"_ci.csv"))

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

let 
    for i = 1:2:5
        @show i 
    end
end