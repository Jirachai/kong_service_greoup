#!/bin/bash

# Set Kong Admin API URL
KONG_ADMIN_URL="http://localhost:8001"
#KONG_ADMIN_TOKEN="<your-token>"
#WORK_SPACE="<<<>>>"
SERVICE_NAME="svc_gerneral_obkect"

echo "Adding serverless function plugin"

# Add Serverless Functions Plugin
curl -s -X POST "$KONG_ADMIN_URL/plugins" \
    -H "Content-Type: application/json" \
    -d '{
        "name": "serverless-functions",
        "service": { "name": "'"$SERVICE_NAME"'" },
        "config": {
            "access": "local path = kong.request.get_path()\nif path:find(\"/api/v1/\") then\n    kong.service.set_upstream(\"upstream-v1\")\nelif path:find(\"/api/v2/\") then\n    kong.service.set_upstream(\"upstream-v2\")\nelse\n    kong.service.set_upstream(\"default-upstream\")\nend"
        }
    }'

echo "Service, routes, and plugins created successfully!"

