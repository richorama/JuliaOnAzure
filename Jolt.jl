##### TODO
# json response
# body parser
# serve files
# splat on url matching
# ...

module Jolt

using RouteParser
using HttpServer


export jolt
export Action

abstract Action

immutable Route
	path::String
	method::Symbol
	handler::Function
end

type Context
	params::Dict{Symbol,String}
end

type App
	routes::Array{Route,1} 
	middleware::Array{Function,1}
	get::Function
	use::Function
	selectRoute::Function
	dispatch::Function

	function App()
		instance = new()
		instance.routes = Route[]
		instance.middleware = Function[]
		
		# add a route to the routing table
		instance.get = function(handler::Function, path::String)
			push!(instance.routes, Route(path, :get, handler))
		end

		instance.use = function(handler::Function)
			push!(instance.middleware, handler)
		end

		# select a route from a routing table based on a URL and method
		instance.selectRoute = function(path::String, method::Symbol)
			for route in filter((route) -> route.method == method || route.method == :any, instance.routes)
				params = isMatch(path, route.path)
				if (nothing != params)
					return (route,params)
				end
			end
		end

		# run a route
		instance.dispatch = function(req::Request, res::Response)
			println(res)
			routeMatch = instance.selectRoute(req.resource,symbol(lowercase(req.method)))
			
			if nothing == routeMatch
				return Response(404, res.headers, "Route not found", true)
			end
			(route, params) = routeMatch
			ctx = Context(params)

			middlewares = Task[]
			for mware in instance.middleware
				func = Task(() -> mware(req, res, ctx))
				push!(middlewares, func)
				if nothing == consume(func)
					return Response(500, "middleware has stopped the request")
				end
			end

			output = route.handler(req, res, ctx)

			if isa(output,Action)
				output = output.dispatch(req, res, ctx)
			end

			for func in middlewares
				consume(func)
			end

			Response(res.status, res.headers, output, true)
		end

		# return the instance
		instance
	end

end

function jolt()
	App()
end

end #module