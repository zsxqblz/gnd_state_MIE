function clusterCoor2Idx(coor::Vector{Int64},dx::Int64,dy::Int64)
    return mod(coor[2],dy) * dx + mod(coor[1],dx) + 1
end

function genClusterSqrIdx(xi::Int64,xf::Int64,yi::Int64,yf::Int64,dx::Int64,dy::Int64)
    idxArr = Vector{Int64}(undef,(xf-xi+1)*(yf-yi+1))
    cnt = 1
    for iy = (yi-1):(yf-1)
        for ix = (xi-1):(xf-1)
            idxArr[cnt] = clusterCoor2Idx([ix,iy],dx,dy)
            cnt = cnt + 1
        end
    end
    return idxArr
end

function genClusterDiagIdx(xi::Int64,yi::Int64,length::Int64,dx::Int64,dy::Int64,lower::Bool=true)
    idxArr = Vector{Int64}(undef,length)
    cnt = 1
    for offset = 0:(length-1)
        coorx = xi-1+offset
        coory = yi-1-offset
        if lower
            idxArr[cnt] = toricCoor2Idx([coorx,coory],dx,dy)
        else
            idxArr[cnt] = toricCoor2Idx([coorx+1,coory+1],dx,dy)
        end
        cnt = cnt + 1
    end
    return idxArr
end

function genClusterXIdx(dx::Int64,dy::Int64)
    XIdxArr = Matrix{Int64}(undef,4,dx*dy)
    cnt = 1
    for iy = 0:(dy-1)
        for ix = 0:(dx-1)
            XIdxArr[1,cnt] = clusterCoor2Idx([ix,iy],dx,dy)
            XIdxArr[2,cnt] = clusterCoor2Idx([ix+1,iy],dx,dy)
            XIdxArr[3,cnt] = clusterCoor2Idx([ix,iy+1],dx,dy)
            XIdxArr[4,cnt] = clusterCoor2Idx([ix+1,iy+1],dx,dy)
            cnt = cnt + 1
        end
    end
    return XIdxArr
end

function genClusterZIdx(dx::Int64,dy::Int64)
    ZIdxArr = Matrix{Int64}(undef,1,dx*dy)
    cnt = 1
    for iy = 0:(dy-1)
        for ix = 0:(dx-1)
            ZIdxArr[1,cnt] = clusterCoor2Idx([ix,iy],dx,dy)
            cnt = cnt + 1
        end
    end
    return ZIdxArr
end



function genCluster(dx::Int64,dy::Int64)
    nsites = dx*dy
    s = zero(Stabilizer,nsites)
    XIdxArr = genClusterXIdx(dx,dy)
    ZIdxArr = genClusterZIdx(dx,dy)
    for (i,XIdx) in enumerate(eachcol(XIdxArr))
        s[i,XIdx[1]] = (true,false)
        s[i,XIdx[2]] = (true,false)
        s[i,XIdx[3]] = (true,false)
        s[i,XIdx[4]] = (true,false)
    end

    for (i,ZIdx) in enumerate(eachcol(ZIdxArr))
        s[i,ZIdx[1]] = (false,true)
    end
    canonicalize!(s)


    boolStr = Vector{Bool}(undef,nsites)
    reg = Register(MixedDestabilizer(s), boolStr)
    return reg
    
end