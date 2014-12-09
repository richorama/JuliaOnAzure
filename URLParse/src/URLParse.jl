module URLParse

warn("""
The URLParse.jl package has been deprecated in favour of JuliaWeb/URIParser.jl
https://github.com/JuliaWeb/URIParser.jl
As of Julia 0.4 this package will no longer be installable 
through `Pkg.add`. Please convert your code accordingly.""")


import Base.copy

export URLComponents,
        urlsplit, urlunsplit, urlparse, urlunparse, urldefrag,
        username, password, hostname, port,
        copy,
        escape, escape_form, escape_with, unescape, unescape_form

#include("strutils.jl")
include("urlescape.jl")

# A classification of schemes ('' means apply by default)
const uses_relative = ["hdfs", "ftp", "http", "gopher", "nntp", "imap", "wais", "file", "https", "shttp", "mms", "prospero", "rtsp", "rtspu", "", "sftp", "svn", "svn+ssh"]
const uses_netloc = ["hdfs", "ftp", "http", "gopher", "nntp", "telnet", "imap", "wais", "file", "mms", "https", "shttp", "snews", "prospero", "rtsp", "rtspu", "rsync", "", "svn", "svn+ssh", "sftp" ,"nfs", "git", "git+ssh"]
const uses_params = ["ftp", "hdl", "prospero", "http", "imap", "https", "shttp", "rtsp", "rtspu", "sip", "sips", "mms", "", "sftp", "tel"]

# These are not actually used anymore, but should stay for backwards
# compatibility.  (They are undocumented, but have a public-looking name.)
const non_hierarchical = ["gopher", "hdl", "mailto", "news", "telnet", "wais", "imap", "snews", "sip", "sips"]
const uses_query = ["http", "wais", "imap", "https", "shttp", "mms", "gopher", "rtsp", "rtspu", "sip", "sips", ""]
const uses_fragment = ["hdfs", "ftp", "hdl", "http", "gopher", "news", "nntp", "wais", "https", "shttp", "snews", "file", "prospero", ""]
const scheme_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-."


type URLComponents
    scheme::String
    netloc::String
    url::String
    params::String
    query::String
    fragment::String

    _username::Union(String, Bool, Nothing)
    _password::Union(String, Bool, Nothing)
    _hostname::Union(String, Bool, Nothing)
    _port::Union(Int, Bool, Nothing)

    function URLComponents(scheme::String, netloc::String, url::String, params::String, query::String, fragment::String)
        new(scheme, netloc, url, params, query, fragment, nothing, nothing, nothing, nothing)
    end
end

const MAX_CACHE_SIZE = 20
const _parse_cache = Dict{(String, String, Bool),URLComponents}()

clear_cache() = empty!(_parse_cache)
copy(up::URLComponents) = URLComponents(up.scheme, up.netloc, up.url, up.params, up.query, up.fragment)

function _parse_user_name_password(up::URLComponents)
    netloc = up.netloc
    if('@' in netloc)
        userinfo = rsplit(netloc, '@', 2)[1]
        if(':' in userinfo)
            spl = split(userinfo, ':', 2)
            up._username = spl[1]
            up._password = (length(spl) > 1) ? spl[2] : false
        else
            up._username = userinfo
            up._password = false
        end
    else
        up._username = up._password = false
    end
end

function _parse_hostname_port(up::URLComponents)
    netloc = rsplit(up.netloc, '@', 2)[end]
    lb = search(netloc, '[')
    rb = search(netloc, ']')
    cpos = rsearch(netloc, ':')
    if((lb > 0) && (rb > 0))
        up._hostname = lowercase(netloc[lb+1:rb-1])
    elseif(cpos > 0)
        up._hostname = lowercase(netloc[1:cpos-1])
    elseif(length(netloc) > 0)
        up._hostname = lowercase(netloc)
    else
        up._hostname = up._port = false
    end

    if((false != up._port) && (cpos > 0) && ((rb == 0) || (cpos > rb)))
        up._port = int(netloc[cpos+1:end])
    else
        up._port = false
    end
end

# returns the username string or nothing if it was not specified in the url
function username(up::URLComponents)
    (nothing != up._username) && (return (false == up._username) ? nothing : up._username)
    _parse_user_name_password(up)
    return (false == up._username) ? nothing : up._username
end

# returns the password string or nothing if it was not specified in the url
function password(up::URLComponents)
    (nothing != up._username) && (return (false == up._password) ? nothing : up._password)
    _parse_user_name_password(up)
    return (false == up._password) ? nothing : up._password
end

# returns the hostname string or nothing if it was not specified in the url
function hostname(up::URLComponents)
    (nothing != up._hostname) && (return (false == up._hostname) ? nothing: up._hostname)
    _parse_hostname_port(up)
    return (false == up._hostname) ? nothing : up._hostname
end

# returns the port (int) or nothing if it was not specified in the url
function port(up::URLComponents)
    (nothing != up._port) && (return (false == up._port) ? nothing: up._port)
    _parse_hostname_port(up)
    return (false == up._port) ? nothing : up._port
end

function _splitparams(url)
    slash_pos = rsearch(url, '/')
    sc_pos = 0
    if(slash_pos > 0)
        sc_pos = search(url, ';', slash_pos)
        (sc_pos < 1) && (return (url, ""))
    else
        sc_pos = search(url, ';')
    end
    (sc_pos < 1) ? (url, url) : (url[1:sc_pos-1], url[sc_pos+1:end])
end

function _splitnetloc(url::String, start::Int=1)
    delim = length(url)+1                     # position of end of domain part of url, default is end
    for c in "/?#"                            # look for delimiters; the order is NOT important
        wdelim = search(url, c, start)        # find first of this delim
        if (wdelim > 0)                        # if found
            delim = min(delim, wdelim)        # use earliest delim position
        end
    end
    return _chk_invalid_ipv6(url[start:delim-1]), url[delim:end]   # return (domain, rest)
end

function _chk_invalid_ipv6(netloc::String)
    lb = search(netloc, '[')
    rb = search(netloc, ']')
    if( ((lb > 0) && (rb == 0)) || ((lb == 0) && (rb > 0)))
        error("Invalid IPV6 URL")
    end
    netloc
end


##
# Parse a URL into 6 components:
# <scheme>://<netloc>/<path>;<params>?<query>#<fragment>
function urlparse(url::String, scheme::String="", allow_fragments::Bool=true)
    up = urlsplit(url, scheme, allow_fragments)
    if (up.scheme in uses_params) && (';' in url)
        up.url, up.params = _splitparams(up.url)
    end
    up
end

##
# Parse a URL into 5 components:
# <scheme>://<netloc>/<path>?<query>#<fragment>
function urlsplit(url::String, scheme::String="", allow_fragments::Bool=true)
    key = (url, scheme, allow_fragments)
    if(haskey(_parse_cache, key))
        return _parse_cache[key]
    end
    (length(_parse_cache) >= MAX_CACHE_SIZE) && empty!(_parse_cache)
    
    netloc = ""; query = ""; fragment = ""
    i = search(url, ':')
    if(i > 1)
        if(url[1:(i-1)] == "http")  # optimize the common case
            scheme = lowercase(url[1:(i-1)])
            url = url[i+1:end]
            if(beginswith(url, "//"))
                netloc, url = _splitnetloc(url, 3)
            end
            if(allow_fragments && ('#' in url))
                url, fragment = tuple(split(url, '#', 2)...)
            end
            if('?' in url)
                url, query = tuple(split(url, '?', 2)...)
            end
            return _parse_cache[key] = URLComponents(scheme, netloc, url, "", query, fragment)
        end
        urlinvalidchars = false
        for ci in 1:(i-1)
            !(url[ci] in scheme_chars) && (urlinvalidchars = true) && break
        end
        if(!urlinvalidchars)
            try
                _testportnum = int(url[i+1:end])
            catch
                scheme = lowercase(url[1:i-1])
                url = url[i+1:end]
            end
        end
    end
    if(beginswith(url, "//"))
        netloc, url = _splitnetloc(url, 3)
    end

    scheme_uses_fragment = (scheme in uses_fragment)
    scheme_uses_query = (scheme in uses_query)
    if (allow_fragments && scheme_uses_fragment && ('#' in url))
        url, fragment = tuple(split(url, '#', 2)...)
    end
    if (scheme_uses_query && ('?' in url))
        url, query = tuple(split(url, '?', 2)...)
    end
    return _parse_cache[key] = URLComponents(scheme, netloc, url, "", query, fragment)
end

urlunparse(up::URLComponents) = urlunsplit(up, true)
function urlunsplit(up::URLComponents, add_params::Bool=false)
    has_netloc = (length(up.netloc) > 0)
    has_scheme = (length(up.scheme) > 0)
    scheme_uses_netloc = has_scheme && (up.scheme in uses_netloc)
    url = (add_params && (length(up.params) > 0)) ? (up.url * ";" * up.params) : up.url
    if (has_netloc || (has_scheme && scheme_uses_netloc && !beginswith(url, "//")))
        if((length(url) > 0) && (url[1] != '/')) 
            url = "/" * url
        end
        url = "//" * up.netloc * url
    end
    has_scheme && (url = up.scheme * ":" * url)
    (length(up.query) > 0) && (url = url * "?" * up.query)
    (length(up.fragment) > 0) && (url = url * "#" * up.fragment)
    url
end

##
# Removes any existing fragment from URL.
# Returns a tuple of the defragmented URL and the fragment.  If
#    the URL contained no fragments, the second element is the
#    empty string.
function urldefrag(url::String)
    if('#' in url)
        up = copy(urlparse(url))
        frag = up.fragment
        up.fragment = ""
        defrag = urlunparse(up)
        return defrag, frag
    end
    return url, ""
end

end
