using URLParse
using Base.Test


#############################
# generate test code
# To make it easy to write regression tests:
# Add a URL into urls
# Run test.jl (this file) with gen in the command line and redirect output to "do_gen_tests.jl"
# Verify that the generated test code is ok.
# Run test.jl anytime without any parameters to run regression tests
function gen_test(url::String)
    up = urlparse(url)
    println("    println(\"testing url: $(url)\")")
    println("    up = urlparse(\"$(url)\")")
    println("    @test up.scheme == \"$(up.scheme)\"")
    println("    @test up.netloc == \"$(up.netloc)\"")
    println("    @test up.url == \"$(up.url)\"")
    println("    @test up.params == \"$(up.params)\"")
    println("    @test up.query == \"$(up.query)\"")
    println("    @test up.fragment == \"$(up.fragment)\"")
    println("    @test string(hostname(up)) == \"$(hostname(up))\"")
    println("    @test string(port(up)) == \"$(port(up))\"")
    println("    @test string(username(up)) == \"$(username(up))\"")
    println("    @test string(password(up)) == \"$(password(up))\"")
    println("    @test urlunparse(up) == \"$(url)\"")
    println("")
end

const urls = ["hdfs://user:password@hdfshost:9000/root/folder/file.csv", 
    "https://user:password@httphost:9000/path1/path2;paramstring?q=a&p=r#frag",
    "ftp://ftp.is.co.za/rfc/rfc1808.txt", "http://www.ietf.org/rfc/rfc2396.txt", 
    "ldap://[2001:db8::7]/c=GB?objectClass?one", "mailto:John.Doe@example.com", 
    "news:comp.infosystems.www.servers.unix", "tel:+1-816-555-1212", "telnet://192.0.2.16:80/", 
    "urn:oasis:names:specification:docbook:dtd:xml:4.1.2"]

function gen_tests()
    println("function do_gen_tests()")
    for url in urls
        gen_test(url)
    end
    println("end");
end

include("do_gen_tests.jl")

const do_gen = isempty(ARGS) ? false : ("gen" == ARGS[1])

if(do_gen)
    gen_tests()
else
    do_gen_tests()
end

