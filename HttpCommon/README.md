# HttpCommon.jl

[![Build Status](https://travis-ci.org/JuliaWeb/HttpCommon.jl.svg?branch=master)](https://travis-ci.org/JuliaWeb/HttpCommon.jl)
[![Coverage Status](https://img.shields.io/coveralls/JuliaWeb/HttpCommon.jl.svg)](https://coveralls.io/r/JuliaWeb/HttpCommon.jl)

**Installation**: `julia> Pkg.add("HttpCommon")`

This package provides types and helper functions for dealing with the HTTP protocol in Julia:

* types to represent `Request`s, `Response`s, and `Headers`
* a dictionary of `STATUS_CODES`
    (maps integer codes to string descriptions; covers all the codes from the RFCs)
* a bitmask representation of HTTP request methods
* a function to `escapeHTML` in a `String`
* a pair of functions to `encodeURI` and `decodeURI`
* a function to turn a query string from a url into a `Dict{String,String}`


## Documentation
### Request

A `Request` represents an HTTP request sent by a client to a server. 

    :::julia
    type Request
        method::String
        resource::String
        headers::Headers
        data::String
    end

* `method` is an HTTP methods string ("GET", "PUT", etc)
* `resource` is the url resource requested ("/hello/world")
* `headers` is a `Dict` of field name `String`s to value `String`s
* `data` is the data in the request

### Response

A `Response` represents an HTTP response sent to a client by a server.

    :::julia
    type Response
        status::Int
        headers::Headers
        data::HttpData
        finished::Bool
    end

* `status` is the HTTP status code (see `STATUS_CODES`) [default: `200`]
* `headers` is the `Dict` of headers [default: `headers()`, see Headers below]
* `data` is the response data (as a `String` or `Array{Uint8}`) [default: `""`]
* `finished` is `true` if the `Reponse` is valid, meaning that it can be converted to an actual HTTP response [default: `false`]

There are a variety of constructors for `Response`, which set sane defaults for unspecified values.

    :::julia
    Response([statuscode::Int])
    Response(statuscode::Int,[h::Headers],[d::HttpData])
    Response(d::HttpData,[h::Headers])


### Headers

`Headers` is a type alias for `Dict{String,String}`.
There is a default constructor, `headers`, to produce a reasonable default set of headers.
The defaults are as follows:

    :::julia
    [ "Server" => "Julia/$VERSION",
      "Content-Type" => "text/html; charset=utf-8",
      "Content-Language" => "en",
      "Date" => RFC1123_datetime()]

The last setting, `"Date"` uses another HttpCommon function:

    :::julia
    RFC1123_datetime([CalendarTime])
    
When an argument is not provided, the current time (`now()`) is used.
RFC1123 describes the correct format for putting timestamps into HTTP headers.

### STATUS_CODES

`STATUS_CODES` is a `const` `Dict{Int,String}`.
It maps all the status codes defined in RFC's to their descriptions.

    :::julia
    STATUS_CODES[200] #=> "OK"
    STATUS_CODES[404] #=> "Not Found"
    STATUS_CODES[418] #=> "I'm a teapot"
    STATUS_CODES[500] #=> "Internal Server Error"
    
### HttpMethodBitmasks

HttpCommon provides `Int` bitmasks to represent the HTTP request methods
(GET, POST, PUT, UPDATE, DELETE, OPTIONS, HEAD).
There are two dictionaries, `HttpMethodNameToBitmask` and `HttpMethodBitmaskToName`, to allow for mapping back and forth from `String` names to `Int` bitmasks.

The purpose of having bitmasks is that you can write `GET | POST | UPDATE` and end up with a bitmask representing the union of those HTTP methods.

### escapeHTML(i::String)

`escapeHTML` will return a new `String` with the following characters escaped: `&`, `<`, `>`, `"`.

### encodeURI(decoded::String)

`encodeURI` returns a new, URI-safe string.
It escapes all non-URI characters (only letters, digits, `-`, `_` , `.`, and `~` are allowed) in the standard way.

### decodeURI(encoded::String)

`decodeURI` returns a new `String` with all the unsafe characters returned to their original meanings.
It works with the output of `encodeURI` as well as other standard URI encoders.

### parsequerystring(query::String)

`parsequerystring` takes a query string (as from a URL) and returns a `Dict{String,String}` representing the same data.

An example:

    :::julia
     q = "foo=bar&baz=%3Ca%20href%3D%27http%3A%2F%2Fwww.hackershool.com%27%3Ehello%20world%21%3C%2Fa%3E"
    parsequerystring(q)
    # => ["foo"=>"bar","baz"=>"<a href='http://www.hackershool.com'>hello world!</a>"]



---

~~~~
:::::::::::::
::         ::
:: Made at ::
::         ::
:::::::::::::
     ::
Hacker School
:::::::::::::
~~~~
