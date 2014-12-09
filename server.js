require('http').createServer(function(req, res){res.end(process.env.port);}).listen(process.env.port);

/*
push!(LOAD_PATH, ".")
push!(LOAD_PATH, "C:\\Users\\Richard\\Code\\Jolt - Azure")



for x in ENV
   println(x)
end


using HttpServer
using Jolt
using JoltView
using JoltJson

app = jolt()

app.use() do req, res, ctx
	url = req.resource
	println("start $url")
	produce()
	println("end $url")
end

app.get("/") do req, res, ctx
	"hello world"
end

app.get("/hello/:name") do req, res, ctx
	name = ctx.params[:name]
	"hello $name"
end

app.get("/view/:name") do req, res, ctx
	View("test", {"Name" => ctx.params[:name]})
end

app.get("/json/:foo") do req, res, ctx
	x = Dict{String,Any}()
	x["foo"] = ctx.params[:foo]
	Json(x)
end

http = HttpHandler(app.dispatch) 
server = Server(http)
run_pipe(server, ENV["PORT"])

*/