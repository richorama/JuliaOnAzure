# source: https://github.com/dirk/HTTP.jl/blob/master/src/HTTP/Util.jl

escaped_regex = r"%([0-9a-fA-F]{2})"

function unescape(str)
    # def _unescape(str, regex) str.gsub(regex){ $1.hex.chr } end
    for m in eachmatch(escaped_regex, str)
        for capture in m.captures
            rep = string(char(parseint(capture, 16)))
            str = replace(str, "%"*capture, rep)
        end
    end
    return str
end

function unescape_form(str)
    str = replace(str, "+", " ")
    return unescape(str)
end


# Escaping
control_array = convert(Array{Uint8,1}, [vec(0:(parseint("1f", 16)))])
control = utf8(ascii(control_array)*"\x7f")
space = utf8(" ")
delims = utf8("%<>\"")
unwise   = utf8("{}|\\^`")
nonascii_array = convert(Array{Uint8,1}, [vec(parseint("80", 16):(parseint("ff", 16)))])

reserved = utf8(",;/?:@&=+\$![]'*#")
# Strings to be escaped
# (Delims goes first so '%' gets escaped first.)
unescaped = delims * reserved * control * space * unwise# * nonascii
unescaped_form = delims * reserved * control * unwise# * nonascii
# Escapes chars (in second string); also escapes all non-ASCII chars.
function escape_with(str, use)
    chars = split(use, "")
      
    for c in chars
        _char = c[1] # Character string as Char
        h = hex(int(_char))
        if length(h) < 2
            h = "0"*h
        end
        str = replace(str, c, "%" * h)
    end
      
    for i in nonascii_array
        str = replace(str, char(i), "%" * hex(i))
    end
      
    return str
end
    
function escape(str)
    return escape_with(str, unescaped)
end

function escape_form(str)
    str = escape_with(str, unescaped_form)
    return replace(str, " ", "+")
end

