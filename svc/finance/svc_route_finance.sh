#!/bin/bash

# Set your Kong Admin API URL and authentication token
KONG_ADMIN="http://127.0.0.1:8001"
KONG_ADMIN_TOKEN="<your-token>"
WORK_SPACE="Finance"

# Service details
SERVICE_NAME="svc_finance"
SERVICE_URL="http://thd-liberty.th.msig.com:10002"
SERVICE_TAGS='["uat", "finance"]'

# Create the service
echo "Creating service: $SERVICE_NAME..."
curl -s -X POST "$KONG_ADMIN/$WORK_SPACE/services" \
     -H "Kong-Admin-Token: $KONG_ADMIN_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{
           "name": "'"$SERVICE_NAME"'",
           "url": "'"$SERVICE_URL"'",
	   "tags": '"$SERVICE_TAGS"'
         }' | jq .

# Function to create a route
create_route() {
  ROUTE_NAME=$1
  ROUTE_PATH=$2
  ROUTE_TAGS='["uat", "finance"]'

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

# Create the two routes
create_route "route_rest_payment_2c2p" "/rest/payment/2c2p"
create_route "route_rest_payment_quickpay" "/rest/payment/quickpay" 

echo "Service and routes created successfully!"

