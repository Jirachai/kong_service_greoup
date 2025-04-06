curl -i -X POST http://localhost:8001/services/my-service/plugins \
  --data "name=serverless-functions" \
  --data "config.access=$(cat <<EOF
local path = kong.request.get_path()

local upstreams = {
    [\"/url/api1\"] = \"upstream-api1\",
    [\"/url/api2\"] = \"upstream-api2\",
    [\"/url/api3\"] = \"upstream-api3\",
    [\"/url/api4\"] = \"upstream-api4\"
}

for route_path, upstream in pairs(upstreams) do
    if path:find(route_path, 1, true) then
        kong.service.set_upstream(upstream)
        return
    end
end

kong.response.exit(404, { message = \"No route found for this path\" })
EOF
)"

