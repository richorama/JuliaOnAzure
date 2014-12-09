# Jolt

An experimental sinatra style web framework for Julia

## Example

```julia
using HttpServer
using Jolt
using JoltView

app = jolt()

app.get("/") do req, res, ctx
	"hello world"
end

app.get("/hello/:name") do req, res, ctx
	name = ctx.params[:name]
	"hello $name"
end

http = HttpHandler(app.dispatch) 
server = Server(http)
run(server, 8080)
```

## Middleware

Middleware is achieved with a producer (co-routines)

```julia
app.use() do req, res, ctx
	url = req.resource
	
	println("start $url")
	
	produce()
	
	println("end $url")
end
```

## Views

Views are currently implemented in a Mustache template like this:

```html
<html>
	<body>
		Hello {{Name}}
	</body>
</html>
```

Your controller then just returns a View object and the data to render:

```julia
app.get("/view/:name") do req, res, ctx
	View("test", {"Name" => ctx.params[:name]})
end
```

## JSON

Return a JSON response:

```julia
app.get("/json/:foo") do req, res, ctx
	x = Dict{String,Any}()
	x["foo"] = ctx.params[:foo]
	Json(x)
end
```


## License

MIT