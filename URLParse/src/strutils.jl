
typealias Chars Union(Char,AbstractVector{Char},Set{Char})

# search in a string from the reverse direction
function _rsearch(s::String, c::Chars, i::Integer)
    l = endof(s)
    ret = search(reverse(s), c, l-i+1)
    (0 == ret) ? 0 : (l-ret+1)
end
_rsearch(s::String, c::Chars) = _rsearch(s,c,endof(s))

function _rsearch(s::String, t::String, i::Integer)
    l = endof(s)
    r = search(reverse(s), reverse(t), l-i+1)
    (0 == r.start) ? r : Range1(l-r.start-r.len+2, r.len)
end
_rsearch(s::String, t::String) = _rsearch(s,t,endof(s))

function _rsplit(str::String, splitter, limit::Integer, keep_empty::Bool)
    strs = String[]
    i = start(str)
    n = endof(str)
    r = _rsearch(str,splitter,n)
    j = first(r)-1 
    k = last(r)
    while((0 <= j < n) && (length(strs) != limit-1))
        if(i <= k)
            (keep_empty || (k < n)) && unshift!(strs, str[k+1:n])
            n = j
        end
        (k <= j) && (j = prevind(str,j))
        r = _rsearch(str,splitter,j)
        j = first(r)-1
        k = last(r)
    end
    (keep_empty || (n > 0)) && unshift!(strs, str[1:n])
    return strs
end
_rsplit(s::String, spl, n::Integer) = _rsplit(s, spl, n, true)
_rsplit(s::String, spl, keep::Bool) = _rsplit(s, spl, 0, keep)
_rsplit(s::String, spl)             = _rsplit(s, spl, 0, true)

const _default_delims = [' ','\t','\n','\v','\f','\r']
_rsplit(str::String) = _rsplit(str, _default_delims, 0, false)

