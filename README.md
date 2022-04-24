# roxios

Roxios is a simple, fast, and powerful HttpService wrapper for Roblox, with a focus on mocking the current API in a promise-based format for easy integration into current codebase with little-to-no learning curve. 

https://github.com/FxllenCode/roxios/

Roxios was insipired by [Axios](https://www.npmjs.com/package/axios)!

## Getting Started

### Option 1 - With Wally (Recommended)

To install via [Wally](https://wally.run), add the following to your `wally.toml` file:

```toml
[dependencies]
roxios = "fxllencode/roxios@1.1.5"
```

Then, run `wally install` to install the dependencies.

### Option 2 - With .rbxm

You can also drag and drop `roxios` directly into your project, under `ReplicatedStorage`.

Head to the [releases](https://github.com/FxllenCode/roxios/releases) page to download the latest version, and drag `pack.rbxm` into `ReplicatedStorage`.

### Option 3 - Building from Source Code with Foreman

If you wish, you can also download the source code and build it yourself. In order for this option to work, you **must** have [Foreman](https://github.com/Roblox/foreman) installed. 

Firstly, clone the repository:

```bash
git clone https://github.com/FxllenCode/roxios.git
```

Then, enter the directory you created. With Foreman, run:

```bash
foreman install
```

to install the required tools. 

Then, run: `wally install` to install the dependencies.

Finally, build the `.rbxm` file:

```bash
rojo build -o pack.rbxm pack.project.json
``` 

<hr>

### Testing a sample project

`roxios` includes a sample project for your convience. To run, first clone the repository:

```bash
git clone https://github.com/FxllenCode/roxios.git
```

Then, enter the directory you created. With Foreman, run:

```bash
foreman install
```

to install the required tools. 

Then, run: `wally install` to install the dependencies.

Finally, serve the project via Rojo:

```bash
rojo serve testing.project.json
```

Ensure you connect via Roblox Studio, and hit run!

## Usage

`roxios` is not intended to be a major difference from most other HttpService wrappers. However, it is a bit more powerful, and has a few additional features. 

Firstly, it uses the [promise](https://github.com/evaera/roblox-lua-promise) library to make it easier to work with responses and errors. I suggest you check out the documentation for a full list of features, however to sum it up, you call the function, and then use `:andThen()` to handle the response, or `:catch()` to handle errors.

```lua
local function myFunction()
    return Promise.new(function(resolve, reject, onCancel)
        somethingThatYields()
        resolve("Hello world!")
        if !somethingThatDoesNotYield() then
            reject("Something went wrong!")
        end
    end)
end

myFunction():andThen(print):catch(print)
```


Secondly, it has a mock-example of [HttpRbxApiService](https://developer.roblox.com/en-us/api-reference/class/HttpRbxApiService), which is nearly identical to HttpService, however, it can make requests to the Roblox API, which HttpService cannot do without a proxy. For your convince, there is a function called `RbxApiRequest(options)`, which is essentially a mock of `HttpService:RequestAsync(options)`, however it returns a promise, and uses a proxy.

However, you shouldn't use this in production! There are a multitude of reasons as to why you should not use this, and I will not go into them here. Feel free to continue reading below:

https://devforum.roblox.com/t/psa-stop-using-roblox-proxies/1573256

## API

### ```roxios.Request(options: Options)```

* `options`: The options to pass to `HttpService:RequestAsync(options)` (see [HttpService:RequestAsync](https://developer.roblox.com/en-us/api-reference/function/HttpService/RequestAsync))

**Returns: A promise, which resolves to `parsedResponse, rawResponse`, or rejects with an error.**

### ```roxios.Get(url: string, noCache: boolean?, headers: any?)```

* `url`: The url to request.

* `noCache`: Whether or not to use the cache.

* `headers`: Any headers to pass to the request.

**Returns: A promise, which resolves to `parsedResponse, rawResponse`, or rejects with an error.**

* Note: This is a wrapper for [`HttpService:GetAsync(url, noCache, headers)`](https://developer.roblox.com/en-us/api-reference/function/HttpService/GetAsync)

### ```roxios.Post(url: string, json: string, content_type: Enum.HttpContentType?, compress: boolean?, headers: any?)```

* `url`: The url to request.

* `json`: The json to send.

* `content_type`: The content type to request back.

* `compress`: Whether or not to compress the request.

* `headers`: Any headers to pass to the request.

 **Returns: A promise, which resolves to `parsedResponse, rawResponse`, or rejects with an error.**

* Note: This is a wrapper for [`HttpService:PostAsync(url, body, noCache, headers)`](https://developer.roblox.com/en-us/api-reference/function/HttpService/PostAsync)

### ```roxios.RbxApiRequest(options: Options)```

* `options`: The options to pass to `HttpRbxApiService:RequestAsync(options)` (see [HttpRbxApiService:RequestAsync](https://developer.roblox.com/en-us/api-reference/function/HttpRbxApiService/RequestAsync))

**Returns: A promise, which resolves to `parsedResponse, rawResponse`, or rejects with an error.**



## Example

```lua
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
```

## Contributing

This project uses Foreman to install all toolchains. If you wish to contribute, please fork the repository, and build the project yourself. Make sure you run `selene` and `stylua` before committing any changes, other wise CI may fail.

Please ensure you have tested code before committing. If you have any issues, please open an issue on the [Github repository](https://github.com/FxllenCode/roxios/issues/new).

Make sure you have updated the version in `wally.toml` to the latest SemVer. 

## License

roxios is available under the terms of the MIT License. Terms and conditions are available in LICENSE.txt or at https://opensource.org/licenses/MIT.

