#!/bin/bash

# Set Kong Admin API URL
KONG_ADMIN_URL="http://localhost:8001"

# Create Service
echo "Creating service: my-service"
curl -s -X POST "$KONG_ADMIN_URL/services" \
    -H "Content-Type: application/json" \
    -d '{
        "name": "my-service",
        "url": "http://default-upstream"
    }'

echo "Creating routes"

# Create Route for /api/v1/
curl -s -X POST "$KONG_ADMIN_URL/routes" \
    -H "Content-Type: application/json" \
    -d '{
        "name": "route-v1",
        "service": { "name": "my-service" },
        "paths": ["/api/v1/"],
        "strip_path": true
    }'

# Create Route for /api/v2/
curl -s -X POST "$KONG_ADMIN_URL/routes" \
    -H "Content-Type: application/json" \
    -d '{
        "name": "route-v2",
        "service": { "name": "my-service" },
        "paths": ["/api/v2/"],
        "strip_path": true
    }'

echo "Adding serverless function plugin"

# Add Serverless Functions Plugin
curl -s -X POST "$KONG_ADMIN_URL/plugins" \
    -H "Content-Type: application/json" \
    -d '{
        "name": "serverless-functions",
        "service": { "name": "my-service" },
        "config": {
            "access": "local path = kong.request.get_path()\nif path:find(\"/api/v1/\") then\n    kong.service.set_upstream(\"upstream-v1\")\nelif path:find(\"/api/v2/\") then\n    kong.service.set_upstream(\"upstream-v2\")\nelse\n    kong.service.set_upstream(\"default-upstream\")\nend"
        }
    }'

echo "Service, routes, and plugins created successfully!"

