function do_gen_tests()
    println("testing url: hdfs://user:password@hdfshost:9000/root/folder/file.csv")
    up = urlparse("hdfs://user:password@hdfshost:9000/root/folder/file.csv")
    @test up.scheme == "hdfs"
    @test up.netloc == "user:password@hdfshost:9000"
    @test up.url == "/root/folder/file.csv"
    @test up.params == ""
    @test up.query == ""
    @test up.fragment == ""
    @test string(hostname(up)) == "hdfshost"
    @test string(port(up)) == "9000"
    @test string(username(up)) == "user"
    @test string(password(up)) == "password"
    @test urlunparse(up) == "hdfs://user:password@hdfshost:9000/root/folder/file.csv"

    println("testing url: https://user:password@httphost:9000/path1/path2;paramstring?q=a&p=r#frag")
    up = urlparse("https://user:password@httphost:9000/path1/path2;paramstring?q=a&p=r#frag")
    @test up.scheme == "https"
    @test up.netloc == "user:password@httphost:9000"
    @test up.url == "/path1/path2"
    @test up.params == "paramstring"
    @test up.query == "q=a&p=r"
    @test up.fragment == "frag"
    @test string(hostname(up)) == "httphost"
    @test string(port(up)) == "9000"
    @test string(username(up)) == "user"
    @test string(password(up)) == "password"
    @test urlunparse(up) == "https://user:password@httphost:9000/path1/path2;paramstring?q=a&p=r#frag"

    println("testing url: ftp://ftp.is.co.za/rfc/rfc1808.txt")
    up = urlparse("ftp://ftp.is.co.za/rfc/rfc1808.txt")
    @test up.scheme == "ftp"
    @test up.netloc == "ftp.is.co.za"
    @test up.url == "/rfc/rfc1808.txt"
    @test up.params == ""
    @test up.query == ""
    @test up.fragment == ""
    @test string(hostname(up)) == "ftp.is.co.za"
    @test string(port(up)) == "nothing"
    @test string(username(up)) == "nothing"
    @test string(password(up)) == "nothing"
    @test urlunparse(up) == "ftp://ftp.is.co.za/rfc/rfc1808.txt"

    println("testing url: http://www.ietf.org/rfc/rfc2396.txt")
    up = urlparse("http://www.ietf.org/rfc/rfc2396.txt")
    @test up.scheme == "http"
    @test up.netloc == "www.ietf.org"
    @test up.url == "/rfc/rfc2396.txt"
    @test up.params == ""
    @test up.query == ""
    @test up.fragment == ""
    @test string(hostname(up)) == "www.ietf.org"
    @test string(port(up)) == "nothing"
    @test string(username(up)) == "nothing"
    @test string(password(up)) == "nothing"
    @test urlunparse(up) == "http://www.ietf.org/rfc/rfc2396.txt"

    println("testing url: ldap://[2001:db8::7]/c=GB?objectClass?one")
    up = urlparse("ldap://[2001:db8::7]/c=GB?objectClass?one")
    @test up.scheme == "ldap"
    @test up.netloc == "[2001:db8::7]"
    @test up.url == "/c=GB?objectClass?one"
    @test up.params == ""
    @test up.query == ""
    @test up.fragment == ""
    @test string(hostname(up)) == "2001:db8::7"
    @test string(port(up)) == "nothing"
    @test string(username(up)) == "nothing"
    @test string(password(up)) == "nothing"
    @test urlunparse(up) == "ldap://[2001:db8::7]/c=GB?objectClass?one"

    println("testing url: mailto:John.Doe@example.com")
    up = urlparse("mailto:John.Doe@example.com")
    @test up.scheme == "mailto"
    @test up.netloc == ""
    @test up.url == "John.Doe@example.com"
    @test up.params == ""
    @test up.query == ""
    @test up.fragment == ""
    @test string(hostname(up)) == "nothing"
    @test string(port(up)) == "nothing"
    @test string(username(up)) == "nothing"
    @test string(password(up)) == "nothing"
    @test urlunparse(up) == "mailto:John.Doe@example.com"

    println("testing url: news:comp.infosystems.www.servers.unix")
    up = urlparse("news:comp.infosystems.www.servers.unix")
    @test up.scheme == "news"
    @test up.netloc == ""
    @test up.url == "comp.infosystems.www.servers.unix"
    @test up.params == ""
    @test up.query == ""
    @test up.fragment == ""
    @test string(hostname(up)) == "nothing"
    @test string(port(up)) == "nothing"
    @test string(username(up)) == "nothing"
    @test string(password(up)) == "nothing"
    @test urlunparse(up) == "news:comp.infosystems.www.servers.unix"

    println("testing url: tel:+1-816-555-1212")
    up = urlparse("tel:+1-816-555-1212")
    @test up.scheme == "tel"
    @test up.netloc == ""
    @test up.url == "+1-816-555-1212"
    @test up.params == ""
    @test up.query == ""
    @test up.fragment == ""
    @test string(hostname(up)) == "nothing"
    @test string(port(up)) == "nothing"
    @test string(username(up)) == "nothing"
    @test string(password(up)) == "nothing"
    @test urlunparse(up) == "tel:+1-816-555-1212"

    println("testing url: telnet://192.0.2.16:80/")
    up = urlparse("telnet://192.0.2.16:80/")
    @test up.scheme == "telnet"
    @test up.netloc == "192.0.2.16:80"
    @test up.url == "/"
    @test up.params == ""
    @test up.query == ""
    @test up.fragment == ""
    @test string(hostname(up)) == "192.0.2.16"
    @test string(port(up)) == "80"
    @test string(username(up)) == "nothing"
    @test string(password(up)) == "nothing"
    @test urlunparse(up) == "telnet://192.0.2.16:80/"

    println("testing url: urn:oasis:names:specification:docbook:dtd:xml:4.1.2")
    up = urlparse("urn:oasis:names:specification:docbook:dtd:xml:4.1.2")
    @test up.scheme == "urn"
    @test up.netloc == ""
    @test up.url == "oasis:names:specification:docbook:dtd:xml:4.1.2"
    @test up.params == ""
    @test up.query == ""
    @test up.fragment == ""
    @test string(hostname(up)) == "nothing"
    @test string(port(up)) == "nothing"
    @test string(username(up)) == "nothing"
    @test string(password(up)) == "nothing"
    @test urlunparse(up) == "urn:oasis:names:specification:docbook:dtd:xml:4.1.2"

end
