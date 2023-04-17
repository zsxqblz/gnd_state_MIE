function xzzxCoor2Idx(coor::Vector{Int64},dx::Int64,dy::Int64)
    ddx = 2*dx
    ddy = 2*dy
    return round(Int,mod(coor[2]-mod(coor[2],2),ddy)*ddx/2 + mod(coor[1],ddx) + 1)
end

function genXZZXSqrIdx(xi::Int64,xf::Int64,yi::Int64,yf::Int64,dx::Int64,dy::Int64)
    idxArr = Vector{Int64}(undef,(xf-xi+1)*(yf-yi+1)*2)
    cnt = 1
    for iy = (yi-1):(yf-1)
        for ix = (xi-1):(xf-1)
            coorx = 2*ix+1
            coory = 2*iy+1
            idxArr[cnt] = xzzxCoor2Idx([coorx-1,coory],dx,dy)
            idxArr[cnt+1] = xzzxCoor2Idx([coorx,coory-1],dx,dy)
            cnt = cnt + 2
        end
    end
    return idxArr
end

function genXZZXDiagIdx(xi::Int64,yi::Int64,length::Int64,dx::Int64,dy::Int64,lower::Bool=true)
    idxArr = Vector{Int64}(undef,2*length)
    cnt = 1
    for offset = 0:(length-1)
        coorx = 2*(xi-1+offset)+1
        coory = 2*(yi-1-offset)+1
        if lower
            idxArr[cnt] = xzzxCoor2Idx([coorx-1,coory],dx,dy)
            idxArr[cnt+1] = xzzxCoor2Idx([coorx,coory-1],dx,dy)
        else
            idxArr[cnt] = xzzxCoor2Idx([coorx+1,coory],dx,dy)
            idxArr[cnt+1] = xzzxCoor2Idx([coorx,coory+1],dx,dy)
        end
        cnt = cnt + 2
    end
    return idxArr
end

function genXZZXPlaqIdx(dx::Int64,dy::Int64)
    plaqIdxArr = Matrix{Int64}(undef,4,dx*dy)
    cnt = 1
    for iy = 0:(dy-1)
        for ix = 0:(dx-1)
            coorx = 2*ix+1
            coory = 2*iy+1
            plaqIdxArr[1,cnt] = xzzxCoor2Idx([coorx-1,coory],dx,dy)
            plaqIdxArr[2,cnt] = xzzxCoor2Idx([coorx+1,coory],dx,dy)
            plaqIdxArr[3,cnt] = xzzxCoor2Idx([coorx,coory-1],dx,dy)
            plaqIdxArr[4,cnt] = xzzxCoor2Idx([coorx,coory+1],dx,dy)
            cnt = cnt + 1
        end
    end
    return plaqIdxArr
end

function genXZZXStarIdx(dx::Int64,dy::Int64)
    starIdxArr = Matrix{Int64}(undef,4,dx*dy)
    cnt = 1
    for iy = 0:(dy-1)
        for ix = 0:(dx-1)
            coorx = 2*ix
            coory = 2*iy
            starIdxArr[1,cnt] = xzzxCoor2Idx([coorx-1,coory],dx,dy)
            starIdxArr[2,cnt] = xzzxCoor2Idx([coorx+1,coory],dx,dy)
            starIdxArr[3,cnt] = xzzxCoor2Idx([coorx,coory-1],dx,dy)
            starIdxArr[4,cnt] = xzzxCoor2Idx([coorx,coory+1],dx,dy)
            cnt = cnt + 1
        end
    end
    return starIdxArr
end

function genXZZXCode(dx::Int64,dy::Int64)
    nsites = 2*dx*dy
    s = zero(Stabilizer,nsites)
    plaqIdxArr = genXZZXPlaqIdx(dx,dy)
    starIdxArr = genXZZXStarIdx(dx,dy)
    for (i,plaqIdx) in enumerate(eachcol(plaqIdxArr))
        s[i,plaqIdx[1]] = (true,false)
        s[i,plaqIdx[2]] = (true,false)
        s[i,plaqIdx[3]] = (false,true)
        s[i,plaqIdx[4]] = (false,true)
    end

    for (i,starIdx) in enumerate(eachcol(starIdxArr))
        s[i+dx*dy,starIdx[1]] = (true,false)
        s[i+dx*dy,starIdx[2]] = (true,false)
        s[i+dx*dy,starIdx[3]] = (false,true)
        s[i+dx*dy,starIdx[4]] = (false,true)
    end
    canonicalize!(s)

    # string of x and z horizontally
    # for i in 1:min(dx,dy)
    #     coorx = 2*i-1
    #     coory = 2*i-1
    #     idx = xzzxCoor2Idx([coorx-1,coory],dx,dy)
    #     s[end-1,idx] = (true,false)
    #     idx = xzzxCoor2Idx([coorx,coory+1],dx,dy)
    #     s[end-1,idx] = (false,true)
    #     idx = xzzxCoor2Idx([coorx+1,coory],dx,dy)
    #     s[end,idx] = (false,true)
    #     idx = xzzxCoor2Idx([coorx,coory-1],dx,dy)
    #     s[end,idx] = (true,false)
    # end

    # bell state
    for i in 1:min(dx,dy)
        coorx = 2*i-1
        coory = 2*i-1
        idx = xzzxCoor2Idx([coorx-1,coory],dx,dy)
        s[end-1,idx] = (true,false)
        idx = xzzxCoor2Idx([coorx,coory+1],dx,dy)
        s[end-1,idx] = (false,true)
        idx = xzzxCoor2Idx([coorx+1,coory],dx,dy)
        s[end,idx] = (false,true)
        idx = xzzxCoor2Idx([coorx,coory-1],dx,dy)
        s[end,idx] = (true,false)
    end

    for i in 1:min(dx,dy)
        coorx = 2*dx-2*i+1
        coory = 2*i-1
        idx = xzzxCoor2Idx([coorx+1,coory],dx,dy)
        s[end-1,idx] = (true,false)
        idx = xzzxCoor2Idx([coorx,coory+1],dx,dy)
        s[end-1,idx] = (false,true)
        idx = xzzxCoor2Idx([coorx-1,coory],dx,dy)
        s[end,idx] = (false,true)
        idx = xzzxCoor2Idx([coorx,coory-1],dx,dy)
        s[end,idx] = (true,false)
    end

    # y state
    # for ix = 1:dx
    #     coorx = 2*ix-1
    #     coory = 1
    #     zidx = xzzxCoor2Idx([coorx-1,coory],dx,dy)
    #     xidx = xzzxCoor2Idx([coorx,coory-1],dx,dy)
    #     s[end-1,xidx] = (true,false)
    #     s[end,zidx] = (false,true)
    # end

    # for iy = 1:dy
    #     coorx = 1
    #     coory = 2*iy-1
    #     xidx = xzzxCoor2Idx([coorx-1,coory],dx,dy)
    #     zidx = xzzxCoor2Idx([coorx,coory-1],dx,dy)
    #     s[end,xidx] = (true,false)
    #     s[end-1,zidx] = (false,true)
    # end
    # yidx = xzzxCoor2Idx([1,0],dx,dy)
    # s[end-1,yidx] = (true,true)
    # yidx = xzzxCoor2Idx([0,1],dx,dy)
    # s[end,yidx] = (true,true)

    # return s
    boolStr = Vector{Bool}(undef,nsites)
    reg = Register(MixedDestabilizer(s), boolStr)
    return reg
    
end