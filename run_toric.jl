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
    nsim = parse(Int64,ARGS[8])
    file_name = ARGS[9]

    reg = genToricCode(dx,dy)
    allArr = collect(1:2*dx*dy)


    if mode == 0
        AsitesArr = genToricSqrIdx(1,str_length,1,1,dx,dy)
        CsitesArr = genToricSqrIdx(1,str_length,yi,yi,dx,dy)
    elseif mode == 1
        AsitesArr = genToricDiagIdx(1,yi,str_length,dx,dy,true)
        CsitesArr = genToricDiagIdx(1+offset,yi+offset,str_length+offset,dx,dy,false)
    end

    # yi = 3
    # AsitesArr = genToricDiagIdx(1,yi,yi,dx,dy,true)
    # dlength = yi+idx
    # if dlength > min(dx,dy)
    #     dlength = 2*min(dx,dy) - dlength
    # end
    # CsitesArr = genToricDiagIdx(1+idx,yi+idx,dlength,dx,dy,false)

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
            randYMeasB(treg,BsitesArr,n_meas)
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