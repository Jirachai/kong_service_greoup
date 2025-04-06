#!/bin/bash

# Set your Kong Admin API URL and authentication token
KONG_ADMIN="http://127.0.0.1:8001"
KONG_ADMIN_TOKEN="<your-token>"
WORK_SPACE="default"

# Service details
SERVICE_NAME="svc_finance"
SERVICE_URL="thd-liberty.th.msig.com_25066"
SERVICE_TAGS='["prod", "finance"]'

# Create the service
echo "Creating service: $SERVICE_NAME..."
curl -s -X POST "$KONG_ADMIN/$WORK_SPACE/services" \
     -H "Kong-Admin-Token: $KONG_ADMIN_TOKEN" \	
     -H "Content-Type: application/json" \
     -d '{
           "name": "'"$SERVICE_NAME"'",
           "host": "'"$SERVICE_URL"'",
	   "tags": '"$SERVICE_TAGS"'
         }' | jq .

# Function to create a route
create_route() {
  ROUTE_NAME=$1
  ROUTE_PATH=$2
  ROUTE_TAGS='["prod", "finance"]'

  echo "Creating route: $ROUTE_NAME with path $ROUTE_PATH..."
  curl -s -X POST "$KONG_ADMIN/$WORKSPACE/routes" \
       -H "Content-Type: application/json" \
       -H "Kong-Admin-Token: $KONG_ADMIN_TOKEN" \	
       -d '{
             "name": "'"$ROUTE_NAME"'",
             "paths": ["'"$ROUTE_PATH"'"],
             "strip_path": false,
	     "methods": [],
             "service": { "name": "'"$SERVICE_NAME"'" },
	     "tags": '"$ROUTE_TAGS"'
           }' | jq .
}

# Create the route from function
create_route "route_finance_rest_payment_2c2p" "/rest/payment/2c2p"
create_route "route_finance_rest_payment_quickpay" "/rest/payment/quickpay"
create_route "route_finance_bailbond" "/bailbond"
create_route "route_finance_account_payment" "/account/payment"
create_route "route_finance_account" "/account"
create_route "route_finance_rest" "/rest"

echo "Service and routes created successfully!"

