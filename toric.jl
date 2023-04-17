function toricCoor2Idx(coor::Vector{Int64},dx::Int64,dy::Int64)
    ddx = 2*dx
    ddy = 2*dy
    return round(Int,mod(coor[2]-mod(coor[2],2),ddy)*ddx/2 + mod(coor[1],ddx) + 1)
end

function genToricSqrIdx(xi::Int64,xf::Int64,yi::Int64,yf::Int64,dx::Int64,dy::Int64)
    idxArr = Vector{Int64}(undef,(xf-xi+1)*(yf-yi+1)*2)
    cnt = 1
    for iy = (yi-1):(yf-1)
        for ix = (xi-1):(xf-1)
            coorx = 2*ix+1
            coory = 2*iy+1
            idxArr[cnt] = toricCoor2Idx([coorx-1,coory],dx,dy)
            idxArr[cnt+1] = toricCoor2Idx([coorx,coory-1],dx,dy)
            cnt = cnt + 2
        end
    end
    return idxArr
end

function genToricDiagIdx(xi::Int64,yi::Int64,length::Int64,dx::Int64,dy::Int64,lower::Bool=true)
    idxArr = Vector{Int64}(undef,2*length)
    cnt = 1
    for offset = 0:(length-1)
        coorx = 2*(xi-1+offset)+1
        coory = 2*(yi-1-offset)+1
        if lower
            idxArr[cnt] = toricCoor2Idx([coorx-1,coory],dx,dy)
            idxArr[cnt+1] = toricCoor2Idx([coorx,coory-1],dx,dy)
        else
            idxArr[cnt] = toricCoor2Idx([coorx+1,coory],dx,dy)
            idxArr[cnt+1] = toricCoor2Idx([coorx,coory+1],dx,dy)
        end
        cnt = cnt + 2
    end
    return idxArr
end

function genToricXIdx(dx::Int64,dy::Int64)
    XIdxArr = Matrix{Int64}(undef,4,dx*dy)
    cnt = 1
    for iy = 0:(dy-1)
        for ix = 0:(dx-1)
            coorx = 2*ix+1
            coory = 2*iy+1
            XIdxArr[1,cnt] = toricCoor2Idx([coorx-1,coory],dx,dy)
            XIdxArr[2,cnt] = toricCoor2Idx([coorx+1,coory],dx,dy)
            XIdxArr[3,cnt] = toricCoor2Idx([coorx,coory-1],dx,dy)
            XIdxArr[4,cnt] = toricCoor2Idx([coorx,coory+1],dx,dy)
            cnt = cnt + 1
        end
    end
    return XIdxArr
end

function genToricZIdx(dx::Int64,dy::Int64)
    ZIdxArr = Matrix{Int64}(undef,4,dx*dy)
    cnt = 1
    for iy = 0:(dy-1)
        for ix = 0:(dx-1)
            coorx = 2*ix
            coory = 2*iy
            ZIdxArr[1,cnt] = toricCoor2Idx([coorx-1,coory],dx,dy)
            ZIdxArr[2,cnt] = toricCoor2Idx([coorx+1,coory],dx,dy)
            ZIdxArr[3,cnt] = toricCoor2Idx([coorx,coory-1],dx,dy)
            ZIdxArr[4,cnt] = toricCoor2Idx([coorx,coory+1],dx,dy)
            cnt = cnt + 1
        end
    end
    return ZIdxArr
end

function genToricCode(dx::Int64,dy::Int64)
    nsites = 2*dx*dy
    s = zero(Stabilizer,nsites)
    XIdxArr = genToricXIdx(dx,dy)
    ZIdxArr = genToricZIdx(dx,dy)
    for (i,XIdx) in enumerate(eachcol(XIdxArr))
        s[i,XIdx[1]] = (true,false)
        s[i,XIdx[2]] = (true,false)
        s[i,XIdx[3]] = (true,false)
        s[i,XIdx[4]] = (true,false)
    end

    for (i,ZIdx) in enumerate(eachcol(ZIdxArr))
        s[i+dx*dy,ZIdx[1]] = (false,true)
        s[i+dx*dy,ZIdx[2]] = (false,true)
        s[i+dx*dy,ZIdx[3]] = (false,true)
        s[i+dx*dy,ZIdx[4]] = (false,true)
    end
    canonicalize!(s)

    # string of x and z horizontally
    for i in 1:dx
        s[end-1,2*i] = (true,false)
        s[end,2*i-1] = (false,true)
    end

    # bell state
    # for ix = 1:dx
    #     coorx = 2*ix-1
    #     coory = 1
    #     zidx = toricCoor2Idx([coorx-1,coory],dx,dy)
    #     xidx = toricCoor2Idx([coorx,coory-1],dx,dy)
    #     s[end-1,xidx] = (true,false)
    #     s[end-1,zidx] = (false,true)
    # end

    # for iy = 1:dy
    #     coorx = 1
    #     coory = 2*iy-1
    #     xidx = toricCoor2Idx([coorx-1,coory],dx,dy)
    #     zidx = toricCoor2Idx([coorx,coory-1],dx,dy)
    #     s[end,xidx] = (true,false)
    #     s[end,zidx] = (false,true)
    # end

    # y state
    # for ix = 1:dx
    #     coorx = 2*ix-1
    #     coory = 1
    #     zidx = toricCoor2Idx([coorx-1,coory],dx,dy)
    #     xidx = toricCoor2Idx([coorx,coory-1],dx,dy)
    #     s[end-1,xidx] = (true,false)
    #     s[end,zidx] = (false,true)
    # end

    # for iy = 1:dy
    #     coorx = 1
    #     coory = 2*iy-1
    #     xidx = toricCoor2Idx([coorx-1,coory],dx,dy)
    #     zidx = toricCoor2Idx([coorx,coory-1],dx,dy)
    #     s[end,xidx] = (true,false)
    #     s[end-1,zidx] = (false,true)
    # end
    # yidx = toricCoor2Idx([1,0],dx,dy)
    # s[end-1,yidx] = (true,true)
    # yidx = toricCoor2Idx([0,1],dx,dy)
    # s[end,yidx] = (true,true)

    # return s
    boolStr = Vector{Bool}(undef,nsites)
    reg = Register(MixedDestabilizer(s), boolStr)
    return reg
    
end