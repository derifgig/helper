local ngx = ngx
local cjson = require("cjson")

local function get_cmd_output(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result
end

local hostname = get_cmd_output("hostname"):match("([^\r\n]+)")


local interfaces = {}
local ip_json_output = get_cmd_output("ip -json -4 a")
local ip_data = cjson.decode(ip_json_output)
if ip_data then
    interfaces = ip_data
end

local request_headers = ngx.req.get_headers()
local headers_table = {}
for k, v in pairs(request_headers) do
    headers_table[k] = v
end

local response_data = {
    system = {
        hostname = hostname,
        interfaces = interfaces
    },
    request = {
        method = ngx.req.get_method(),
        uri = ngx.var.uri,
        headers = headers_table
    }
}

ngx.header["Content-Type"] = "application/json"
ngx.say(cjson.encode(response_data))


