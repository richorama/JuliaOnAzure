module JoltView

using Jolt
using Mustache

export View

type View <: Action
	template::String
	data
	dispatch::Function
	function View(template::String, data)
		instance = new()
		instance.template = template
		instance.data = data
		instance.dispatch = function(req, res, ctx)
			tmpl = ""
			open(string(".\\views\\", instance.template, ".html")) do f
				tmpl = readall(f)
			end
			res.headers["Content-Type"] = "text/html"
			render(tmpl, data)
			
		end
		instance
	end
end

end