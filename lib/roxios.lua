-- roxios written by FxllenCode
-- Enjoy! :D

local HttpService = game:GetService("HttpService")
local Promise = require(script.Parent.promise)

local module = {}

type Table<K, V> = {
	[K]: V,
}

type Options = {
	Url: string,
	Method: string?,
	Headers: Table<any, any>,
	Body: string?,
}
function module.Request(options: Options)
	return Promise.new(function(resolve, reject)
		local ok, response = pcall(HttpService.RequestAsync, HttpService, options)

		if ok then
			if response.Success then
				local didParse, parsedResponse = pcall(HttpService.JSONDecode, HttpService, response.Body)
				if didParse then
					resolve(parsedResponse, response)
				else
					warn("Roxios warn: Failed to parse response body as JSON! Setting parsedResponse to nil!")
					resolve(nil, response)
				end
			else
				reject(
					"Roxios error: Request failed with status code "
						.. response.StatusCode
						.. " and message: \n"
						.. response.Body
				)
			end
		else
			reject("Roxios error:\n" .. response)
		end
	end)
end

function module.Get(url: string, noCache: boolean?, headers: Table<any, any>?)
	return Promise.new(function(resolve, reject)
		local ok, response = pcall(HttpService.GetAsync, HttpService, url, noCache or false, headers or nil)
		if ok then
			if response then
				local didParse, parsedResponse = pcall(HttpService.JSONDecode, HttpService, response)
				if didParse then
					resolve(parsedResponse, response)
				else
					warn(
						"Roxios warn: Failed to parse response body as JSON! \n"
							.. parsedResponse
							.. "\n Setting parsedResponse to nil!"
					)
					resolve(nil, response)
				end
			else
				reject("Roxios error: No response from server!")
			end
		else
			reject("Roxios error:\n" .. response)
		end
	end)
end

function module.Post(
	url: string,
	json: string,
	content_type: Enum.HttpContentType?,
	compress: boolean?,
	headers: Table<any, any>?
)
	return Promise.new(function(resolve, reject)
		local ok, response = pcall(
			HttpService.PostAsync,
			HttpService,
			url,
			json,
			content_type or Enum.HttpContentType.ApplicationJson,
			compress or false,
			headers or nil
		)
		if ok then
			if response then
				local didParse, parsedResponse = pcall(HttpService.JSONDecode, HttpService, response)
				if didParse then
					resolve(parsedResponse, response)
				else
					warn(
						"Roxios warn: Failed to parse response body as JSON! \n"
							.. parsedResponse
							.. "\n Setting parsedResponse to nil!"
					)
					resolve(nil, response)
				end
			else
				reject("Roxios error: No response from server!")
			end
		else
			reject("Roxios error:\n" .. response)
		end
	end)
end

function module.RbxApiRequest(options: Options)
	return Promise.new(function(resolve, reject)
		if options.Url == nil then
			reject("Roxios error: No URL provided")
		end
		if string.find(options.Url, "roblox.com") == nil then
			reject("Roxios error: URL is not a Roblox URL!")
		end

		options.Url = string.gsub(options.Url, "roblox.com", "roproxy.com") -- why you shouldn't use this: https://devforum.roblox.com/t/psa-stop-using-roblox-proxies/1573256
		local ok, response = pcall(HttpService.RequestAsync, HttpService, options)
		if ok then
			if response.Success then
				local didParse, parsedResponse = pcall(HttpService.JSONDecode, HttpService, response.Body)
				if didParse then
					resolve(parsedResponse, response)
				else
					warn(
						"Roxios warn: Failed to parse response body as JSON! \n"
							.. parsedResponse
							.. "\n Setting parsedResponse to nil!"
					)
					resolve(nil, response)
				end
			else
				reject(
					"Roxios error: Request failed with status code "
						.. response.StatusCode
						.. " and message: \n"
						.. response.Body
				)
			end
		else
			reject("Roxios error:\n" .. response)
		end
	end)
end

return module
