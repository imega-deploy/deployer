local json = require "cjson"

local token = ngx.req.get_headers()["token"]

if token ~= ngx.var.token then
    ngx.log(ngx.ERR, "Token is invalid")
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.exit(ngx.status)
end

ngx.req.read_body()
local body = ngx.req.get_body_data()

-- Determine whether a variable is empty
--
-- @return bool
function empty(value)
    return value == nil or value == ""
end

local ok, data = pcall(json.decode, body)
if not ok then
    ngx.log(ngx.ERR, "Fail parse json")
    ngx.status = ngx.HTTP_BAD_REQUEST
    ngx.exit(ngx.status)
end


local namespace, err = ngx.re.match(data.namespace, "^([a-z0-9-]+)$")
if empty(namespace) then
    ngx.log(ngx.ERR, "namespace is skewed")
    ngx.status = ngx.HTTP_BAD_REQUEST
    ngx.exit(ngx.status)
end

local project_name = ngx.re.match(data.project_name, "^([a-z0-9-]+)$")
if empty(project_name) then
    ngx.log(ngx.ERR, "project_name is skewed")
    ngx.status = ngx.HTTP_BAD_REQUEST
    ngx.exit(ngx.status)
end

local tag = ngx.re.match(data.tag, "^([a-z0-9-]+)$")
if empty(tag) then
    ngx.log(ngx.ERR, "tag is skewed")
    ngx.status = ngx.HTTP_BAD_REQUEST
    ngx.exit(ngx.status)
end

ngx.eof()

os.execute("cd /tmp; git clone https://github.com/imega-deploy/main.git")
os.execute("cd /tmp/main; make deploy-" .. namespace[1] .. "-" .. project_name[1] .. "TAG=" .. tag[1])
os.execute("rm -rf /tmp/main")

local webhook = ngx.var.webhook
if not empty(webhook) then
    os.execute("curl -X POST -d '{\"text\":\"Deploy " .. namespace[1] .. "-" .. project_name[1] .. "\"}' " .. webhook)
end
