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
