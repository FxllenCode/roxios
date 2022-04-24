-- roxios written by FxllenCode
-- Enjoy! :D

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HttpService = game:GetService("HttpService")
local Promise = require(ReplicatedStorage.Packages.promise)

local module = {} 

type Options = {
	Url: string,
	Method: string?,
	Headers: table?,
	Body: string?,
}
function module.Request(options: Options)
	return Promise.new(function(resolve, reject) 
	local function request() 
		local response = HttpService:RequestAsync(options)
		if response.Success then
		resolve(HttpService:JSONDecode(response.Body), response)
		else 
		reject("roxios error: Request failed with status code " .. response.StatusCode .. " and message " .. response.Body)
		end
	end
	
	
	local Success, Result = pcall(request)
	if not Success then 
		reject("roxios error: Request Failed: " .. Result)
	end
	end)
	
end

function module.GUID(braces: boolean?)
	return HttpService:GenerateGUID(braces or false)

end

function module.Get(url: string, noCache: boolean?, headers: table?)
	return Promise.new(function(resolve, reject)
		local function request()
			local response = HttpService:GetAsync(url, noCache or false, headers)
			if response.Success then 
			resolve(HttpService:JSONDecode(response.Body), response)
			else 
				reject("roxios error: Request failed with status code " .. response.StatusCode .. " and message " .. response.Body)
			end
		end
		local Success, Result = pcall(request)
		if not Success then
			reject("roxios error: Request Failed: " .. Result)
		end
	end)
end
function module.Decode(input: string) 
	return HttpService:JSONDecode(input)
end
function  module.Encode(input: table)
	return HttpService:JSONEncode(input)
end

function module.Post(url: string, json: string, content_type: Enum.HttpContentType?, compress: boolean?, headers: table?)
	return Promise.new(function(resolve, reject)

		local function request() 
	local response = HttpService:PostAsync(url, json, content_type or Enum.HttpContentType.ApplicationJson, compress or false, headers)
	if response then
		resolve(HttpService:JSONDecode(response), response)
	else 

		reject("roxios error: Request failed with status code " .. response.StatusCode .. " and message " .. response)
	end
end
local Success, Result = pcall(request)
if not Success then
	reject("roxios error: Request Failed: " .. Result)
end
end)
end

function module.RbxApiRequest(options: Options)
		return Promise.new(function(resolve, reject) 
			local function request() 
				if options.Url == nil then 
					reject("roxios error: No URL provided")
				end
				if string.find(options.Url, "roblox.com") == nil then 
					reject("roxios error: URL is not a Roblox URL!")

				end
				
				options.Url = string.gsub(options.Url, "roblox.com", "roproxy.com") -- why you shouldn't use this: https://devforum.roblox.com/t/psa-stop-using-roblox-proxies/1573256
				local response = HttpService:RequestAsync(options)
				if response.Success then
				resolve(HttpService:JSONDecode(response.Body), response)
				else 
				reject("roxios error: Request failed with status code " .. response.StatusCode .. " and message " .. response.Body)
				end
			end
			
			
			local Success, Result = pcall(request)
			if not Success then 
				reject("roxios error: Request Failed: " .. Result)
			end
			end)
end

return module