local roxios = require(game.ReplicatedStorage.roxios)
local HttpService = game:GetService("HttpService")
roxios.Request({
	Url = "http://httpbin.org/post",
	Method = "POST",
	Headers = {
		["Content-Type"] = "application/json",
	},
	Body = HttpService:JSONEncode({ hello = "world" }),
})
	:andThen(function(parsedResponse)
		print(parsedResponse.data)
	end)
	:catch(function(error)
		warn(error)
	end)

roxios.Get("http://httpbin.org/get", true)
	:andThen(function(parsedResponse)
		print(parsedResponse)
	end)
	:catch(function(error)
		warn(error)
	end)

roxios.Post(
	"https://httpbin.org/post",
	HttpService:JSONEncode({ hello = "world" }),
	Enum.HttpContentType.ApplicationJson,
	false
)
	:andThen(function(parsedResponse)
		print(parsedResponse.data)
	end)
	:catch(function(error)
		warn(error)
	end)

roxios.RbxApiRequest({
	Url = "http://setup.roblox.com/version",
	Method = "GET",
	Headers = {
		["Content-Type"] = "application/json",
	},
})
	:andThen(function(parsedResponse, response)
		print(response)
	end)
	:catch(function(error)
		warn(error)
	end)
