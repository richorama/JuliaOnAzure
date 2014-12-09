# URLParse.jl
## This package has been deprecated in favour of [JuliaWeb/URIParser.jl](https://github.com/JuliaWeb/URIParser.jl).

As of Julia 0.4 this package will no longer be installable through `Pkg.add`. Please convert your code according.

---

A parser to parse URL string representation into components and re-create the URL string back from components. Modeled after the python urlparse library. A URL can be of the form:
````
scheme://netloc/path;parameters?query#fragment
````

Also has methods to escape and unescape strings for URLs and form data. (source:  https://github.com/dirk/HTTP.jl/blob/master/src/HTTP/Util.jl)

[![Build Status](https://travis-ci.org/tanmaykm/URLParse.jl.png)](https://travis-ci.org/tanmaykm/URLParse.jl)


URLComponents
-------------
The parsed URL components are stored and returned in an instance of URLComponents. 

Component fields and accessor methods:
*   **scheme**
*   **netloc**
*   **url**
*   **params**
*   **query**
*   **fragment**
*   **username(u::URLComponents)** : Extracts username from the netloc field. Returns a string if present or nothing otherwise.
*   **password(u::URLComponents)** : Extracts password from the netloc field. Returns a string if present or nothing otherwise.
*   **hostname(u::URLComponents)** : Extracts hostname from the netloc field. Returns a string if present or nothing otherwise.
*   **port(u::URLComponents)** : Extracts port from the netloc field. Returns an int if present or nothing otherwise.

There is an internal cache of URLComponents maintained as an optimization for repeated use of same URL string. Therefore, the URLComponents instance returned from urlparse must not be modified. A copy may be created to be modified instrad.


APIs
----
<dl>
    <dt>urlparse(url::String)</dt>
    <dd>Parse a URL into 6 components: <i>scheme://netloc/path;params?query#fragment</i>. Returns an instance of URLComponents.</dd>
    <dt>urlunparse(u::URLComponents)</dt>
    <dd>Join back 6 components of the URL back to recreate a URL string.</dd>
    <dt>urldefrag(url::String)</dt>
    <dd>Removes any existing fragment from URL. Returns a tuple of the defragmented URL and the fragment (empty string if none were there).</dd>
    <dt>escape(str::String)</dt>
    <dd>Returns an escaped form of the string that can be used as a URL parameter</dd>
    <dt>unescape(str::String)</dt>
    <dd>Performs the reverse operation of escape</dd>
    <dt>escape_form(str::String)</dt>
    <dd>Returns an escaped string that can be used in a HTML form submit</dd>
    <dt>unescape_form(str::String)</dt>
    <dd>Performs the reverse operation of escape_form</dd>
</dl>


TODO
----
*   parse\_query\_string: to create a list/dict of name-value pairs
*   urljoin: to overlay a relative url on a base url 
*   is\_valid: validate URL string to be conforming to scheme rules


NOTE
----
In addition to the methods documented above, the following are also exported, in anticipation of being useful elsewhere.
*   **urlsplit** and **urlunsplit**: Similar to urlparse and urlunparse, but ignores the 'parameters' part of the url. That is, assumes URLs of form scheme://netloc/path?query#fragment.

