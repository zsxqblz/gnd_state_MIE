function diffIdx(idxAll::Vector{Int64},idxDiff::Vector{Int64})
    return idxAll[findall(!in(idxDiff),idxAll)]
end

function randZMeasB(reg::Register,BsitesArr::Vector{Int64},nmeas::Int64)
    meas_idx = sample(BsitesArr,nmeas,replace=false)
    for i in meas_idx
        apply!(reg,sMZ(i,i))
    end
end

function randXMeasB(reg::Register,BsitesArr::Vector{Int64},nmeas::Int64)
    meas_idx = sample(BsitesArr,nmeas,replace=false)
    for i in meas_idx
        apply!(reg,sMX(i,i))
    end
end


function randYMeasB(reg::Register,BsitesArr::Vector{Int64},nmeas::Int64)
    meas_idx = sample(BsitesArr,nmeas,replace=false)
    for i in meas_idx
        apply!(reg,sMY(i,i))
    end
end

function randMMeasB(reg::Register,BsitesArr::Vector{Int64},nmeas::Int64)
    meas_idx = sample(BsitesArr,nmeas,replace=false)
    basisRnd = bitrand(nmeas)
    for (i,idx) in enumerate(meas_idx)
        if basisRnd[i]
            apply!(reg,sMZ(idx,idx))
        else
            apply!(reg,sMX(idx,idx))
        end
    end
end

function cmi(reg::Register,AsitesArr::Vector{Int64},BsitesArr::Vector{Int64},CsitesArr::Vector{Int64})
    SAB = entanglement_entropy(reg.stab,vcat(AsitesArr,BsitesArr),Val(:rref))
    SBC = entanglement_entropy(reg.stab,vcat(BsitesArr,CsitesArr),Val(:rref))
    SB = entanglement_entropy(reg.stab,BsitesArr,Val(:rref))
    SABC = entanglement_entropy(reg.stab,vcat(AsitesArr,BsitesArr,CsitesArr),Val(:rref))
    return SAB + SBC - SB - SABC 
end

function mi(reg::Register,AsitesArr::Vector{Int64},CsitesArr::Vector{Int64})
    SA = entanglement_entropy(reg.stab,AsitesArr,Val(:rref))
    SC = entanglement_entropy(reg.stab,CsitesArr,Val(:rref))
    SAC = entanglement_entropy(reg.stab,vcat(AsitesArr,CsitesArr),Val(:rref))
    return SA + SC - SAC 
end

function ci(reg::Register,AsitesArr::Vector{Int64},CsitesArr::Vector{Int64})
    SC = entanglement_entropy(reg.stab,CsitesArr,Val(:rref))
    SAC = entanglement_entropy(reg.stab,vcat(AsitesArr,CsitesArr),Val(:rref))
    return SC - SAC 
end

function save1DData(scan_l,cmi_l,file_name)
    df = DataFrame()
    df.scan_l = scan_l
    df.cmi_l = cmi_l
    CSV.write(file_name, df)
end