#!/bin/bash

# Set your Kong Admin API URL and authentication token
KONG_ADMIN="http://127.0.0.1:8001"
KONG_ADMIN_TOKEN="<your-token>"
WORK_SPACE="default"

# Service details
SERVICE_NAME="svc_policy"
SERVICE_URL="thd-liberty.th.msig.com_25066"
SERVICE_TAGS='["prod", "policy"]'

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
  ROUTE_TAGS='["prod", "policy"]'

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
# Create the route from function
create_route "route_policy_rest_convertPdf" "/rest/convertPdf"
create_route "route_policy_rest_payment_genaral" "/rest/payment/genaral"
create_route "route_policy_rest_PMIService" "/rest/PMIService"
create_route "route_policy_rest_mailing" "/rest/mailing"
create_route "route_policy_rest_ntl" "/rest/ntl"
create_route "route_policy_rest_homecare" "/rest/homecare"
create_route "route_policy_api" "/api"
create_route "route_policy_MSIG_GenlinkWS_jaxrs_GenlinkRS" "/MSIG_GenlinkWS/jaxrs/GenlinkRS"
create_route "route_policy_MSIG_GenlinkWS_jaxrs_GenlinkTARS" "/MSIG_GenlinkWS/jaxrs/GenlinkTARS"
create_route "route_policy_MSIG_IAppWeb" "/MSIG_IAppWeb"
create_route "route_policy_msprinting_service" "/msprinting/service"
create_route "route_policy_masterPrintFactory_service" "/masterPrintFactory/service"
create_route "route_policy_api_request" "/api/request"
create_route "route_policy_api" "/api"
create_route "route_policy_renew_person_accident" "/renew/person/accident"
create_route "route_policy_renew_motor" "/renew/motor"
create_route "route_policy_person_accident" "/person/accident"
create_route "route_policy_motor" "/motor"
create_route "route_policy_home" "/home"
create_route "route_policy_travel_request" "/travel/request"
create_route "route_policy_travel" "/travel"
create_route "route_policy_inbound" "/inbound"
create_route "route_policy_motor_issue" "/motor/issue"
create_route "route_policy_rest_auth" "/rest/auth"

echo "Service and routes created successfully!"

