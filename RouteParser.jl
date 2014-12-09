module RouteParser

#using URIParser

export parsePath
export parseRoute
export isMatch

type RouteSegment
	name::String
	segmentType::Symbol
end

# convert "this/and/that" into ["this", "and", "that"]
function parsePath(path::String)
	#uri = URI(path)
	filter((x) -> x != "", split(path, "/"))
end

# parse a route defined in jolt
function parseRoute(path::String)
	route = parsePath(path)
	segments = RouteSegment[]
	for part in route
		segment = RouteSegment(part, :segment)
		if length(part) == 0 
			continue
		end
		if part[1] == ':'
			segment.segmentType = :variable
		end
		push!(segments, segment)
	end
	segments
end

# test an incoming path against a defined route
function isMatch(path::String, route::String)
	parsedPath = parsePath(path)
	parsedRoute = parseRoute(route)
	if (length(parsedPath) != length(parsedRoute)) 
		return nothing
	end
		
	params = Dict{Symbol,String}()	
	for i = 1:length(parsedPath)
		segment = parsedRoute[i]
		part = parsedPath[i]
		if (segment.segmentType == :variable)
			params[symbol(segment.name[2:end])] = part
			continue
		elseif (segment.segmentType == :segment)
			if (part != segment.name)
				return
			end
		end
	end
	params
end

end #module