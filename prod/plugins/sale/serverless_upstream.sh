#!/bin/bash

# Kong Admin API URL
KONG_ADMIN="http://localhost:8001"

# Service Name
SERVICE_NAME="svc_general_object"

# Serverless Function Logic
SERVERLESS_FUNCTION=$(cat <<EOF
local path = kong.request.get_path()

local upstreams = {
    ["/rest/registerEMail"] = "thd-liberty.th.msig.com_10008",
    ["/rest/PrintingService"] = "thd-liberty.th.msig.com_10018",
}

for route_path, upstream in pairs(upstreams) do
    if path:find(route_path, 1, true) then
        kong.service.set_upstream(upstream)
        return
    end
end

kong.response.exit(404, { message = "No route found for this path" })
EOF
)

# Apply the Serverless Function Plugin to the Service
echo "Applying serverless function plugin to $SERVICE_NAME..."

curl -i -X POST "$KONG_ADMIN/services/$SERVICE_NAME/plugins" \
  --data "name=pre-function" \
  --data-urlencode "config.access=$SERVERLESS_FUNCTION"

echo "Serverless function plugin applied successfully!"

