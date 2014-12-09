module JoltJson

using Jolt
using JSON

export Json

type Json <: Action
	data::Dict{String,Any}
	dispatch::Function
	function Json(data::Dict{String,Any})
		instance = new()
		instance.data = data
		instance.dispatch = function(req, res, ctx)
			res.headers["Content-Type"] = "application/json"
			JSON.json(instance.data)			
		end
		instance
	end
end

end