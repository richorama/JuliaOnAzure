using Base.Test

# router tests
using RouteParser

@test length(parsePath("foo/bar/baz")) == 3
@test parsePath("foo/bar/baz")[1] == "foo"
@test parsePath("/foo/bar/baz")[1] == "foo"

@test length(parseRoute("this/:and/that/:foo")) == 4
@test parseRoute("this/:and/that/:foo")[1].segmentType == :segment
@test parseRoute("this/:and/that/:foo")[2].segmentType == :variable

@test isMatch("/hello/world", "/hello/:world") != nothing
@test isMatch("/goodbye/world", "/hello/:world") == nothing
@test isMatch("/","/") != nothing

@test isMatch("/hello/universe", "/hello/:world")[:world] == "universe"

# jolt tests
using Jolt

app = jolt()

app.get("/hello/:world") do req, res
	print("ok")
end

app.get("/") do req, res
	print("ok")
end

@test length(app.routes) == 2
@test app.routes[1].path == "/hello/:world"

(route,params) = app.selectRoute("/hello/richard", :get)
@test route.path == "/hello/:world"
@test params[:world] == "richard"



