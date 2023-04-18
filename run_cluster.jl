include("dependencies.jl")
include("sim.jl")
include("toric.jl")
include("xzzx.jl")
include("cluster.jl")

let
    dx = parse(Int64,ARGS[1])
    dy = parse(Int64,ARGS[2])
    yi = parse(Int64,ARGS[3])
    offset = parse(Int64,ARGS[4])
    str_length = parse(Int64,ARGS[5])
    # 0 = horizontal
    # 1 = diagonal
    mode = parse(Int64,ARGS[6])
    n_meas_step = parse(Int64,ARGS[7])
    #0=x, 1=y, 2=z
    meas_basis = parse(Int64,ARGS[8])
    nsim = parse(Int64,ARGS[9])
    file_name = ARGS[10]

    reg = genCluster(dx,dy)
    allArr = collect(1:dx*dy)


    if mode == 0
        AsitesArr = genClusterSqrIdx(1,str_length,1,1,dx,dy)
        CsitesArr = genClusterSqrIdx(1,str_length,yi,yi,dx,dy)
    elseif mode == 1
        AsitesArr = genClusterDiagIdx(1,yi,str_length,dx,dy,true)
        CsitesArr = genClusterDiagIdx(1+offset,yi+offset,str_length+offset,dx,dy,false)
    end

    BsitesArr = diffIdx(allArr,AsitesArr)
    BsitesArr = diffIdx(BsitesArr,CsitesArr)

    n_meas_start = length(BsitesArr) % n_meas_step
    n_meas_end = length(BsitesArr)
    n_meas_l = range(n_meas_start,n_meas_end,step=n_meas_step)
    n_meas_length = length(n_meas_l)

    cmi_l = zeros(Float64,n_meas_length)
    mi_l = zeros(Float64,n_meas_length)
    ci_l = zeros(Float64,n_meas_length)

    @showprogress for (i,n_meas) in enumerate(n_meas_l)
        for j in 1:nsim
            treg = deepcopy(reg)
            if meas_basis == 0
                randXMeasB(treg,BsitesArr,n_meas)
            elseif meas_basis == 1
                randYMeasB(treg,BsitesArr,n_meas)
            elseif meas_basis == 2
                randZMeasB(treg,BsitesArr,n_meas)
            end
            cmi_l[i] = cmi_l[i] + cmi(treg,AsitesArr,BsitesArr,CsitesArr)
            mi_l[i] = mi_l[i] + mi(treg,AsitesArr,CsitesArr)
            ci_l[i] = ci_l[i] + ci(treg,AsitesArr,CsitesArr)
        end
    end

    cmi_l = cmi_l./nsim
    mi_l = mi_l./nsim
    ci_l = ci_l./nsim
    save1DData(n_meas_l,cmi_l,string(file_name,"_cmi.csv"))
    save1DData(n_meas_l,mi_l,string(file_name,"_mi.csv"))
    save1DData(n_meas_l,ci_l,string(file_name,"_ci.csv"))
end