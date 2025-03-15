#!/bin/bash

# Set your Kong Admin API URL and authentication token
KONG_ADMIN="http://127.0.0.1:8001"
KONG_ADMIN_TOKEN="<your-token>"

# Service details
SERVICE_NAME="svc_general_object"
SERVICE_URL="http://thd-liberty.th.msig.com:10008"
SERVICE_TAGS='["uat", "general_object"]'
WORK_SPACE="default"

# Create the service with tags
echo "Creating service: $SERVICE_NAME..."
curl -s -X POST "$KONG_ADMIN/$WORK_SPACE/services" \
     -H "Kong-Admin-Token: $KONG_ADMIN_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{
           "name": "'"$SERVICE_NAME"'",
           "url": "'"$SERVICE_URL"'",
           "tags": '"$SERVICE_TAGS"'
         }' | jq .

# Function to create a route with tags
create_route() {
  ROUTE_NAME=$1
  ROUTE_PATH=$2
  ROUTE_TAGS='["uat", "general_object"]'

  echo "Creating route: $ROUTE_NAME with path $ROUTE_PATH..."
  curl -s -X POST "$KONG_ADMIN/$WORK_SPACE/routes" \
       -H "Kong-Admin-Token: $KONG_ADMIN_TOKEN" \
       -H "Content-Type: application/json" \
       -d '{
             "name": "'"$ROUTE_NAME"'",
             "paths": ["'"$ROUTE_PATH"'"],
             "methods": ["GET", "POST"],
             "strip_path": false,
             "service": { "name": "'"$SERVICE_NAME"'" },
             "tags": '"$ROUTE_TAGS"'
           }' | jq .
}

# Create the two routes with tags
create_route "route_rest_registerEMail" "/rest/registerEMail"
create_route "route_rest_PrintingService" "/rest/PrintingService"
create_route "route_rest_PrintingService" "/rest/PrintingService"

# Apply the first plugin to both routes
apply_plugin() {
  ROUTE_NAME=$1
  PLUGIN_NAME=$2
  PLUGIN_CONFIG=$3

  echo "Applying plugin: $PLUGIN_NAME to route: $ROUTE_NAME with config: $PLUGIN_CONFIG"
  curl -s -X POST "$KONG_ADMIN/$WORK_SPACE/plugins" \
       -H "Kong-Admin-Token: $KONG_ADMIN_TOKEN" \
       -H "Content-Type: application/json" \
       -d '{
             "name": "'"$PLUGIN_NAME"'",
             "config": '"$PLUGIN_CONFIG"',
             "route": { "name": "'"$ROUTE_NAME"'" }
           }' | jq .
}

# Plugin configurations
PLUGIN_1_CONFIG='{ "access": ["kong.service.set_target("thd-liberty.th.msig.com", 10008)", "kong.service.set_retries(5)"] }'
PLUGIN_2_CONFIG='{ "access": ["kong.service.set_target("thd-liberty.th.msig.com", 10018)", "kong.service.set_retries(5)"] }'

# Apply plugins to each route
apply_plugin "route-1" "pre-function" "$PLUGIN_1_CONFIG"
apply_plugin "route-2" "pre-function" "$PLUGIN_2_CONFIG"

echo "Service, routes, and plugins applied successfully!"

