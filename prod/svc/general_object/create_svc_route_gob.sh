#!/bin/bash

# Set your Kong Admin API URL and authentication token
KONG_ADMIN="http://127.0.0.1:8001"
KONG_ADMIN_TOKEN="<your-token>"
WORK_SPACE="default"

# Service details
SERVICE_NAME="svc_general_object"
SERVICE_URL="thd-liberty.th.msig.com_25066"
SERVICE_TAGS='["prod", "general_object"]'

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
  ROUTE_TAGS='["prod", "general_group"]'

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
create_route "route_genob_rest_registerEMail" "/rest/registerEMail"
create_route "route_genob_rest_PrintingService" "/rest/PrintingService"
create_route "route_genob_rest_otpservice" "/rest/otpservice"
create_route "route_genob_api_repair" "/api/repair"
create_route "route_genob_api_report" "/api/report"
create_route "route_genob_rest_logcenter" "/rest/logcenter"
create_route "route_genob_rest_logsms" "/rest/logsms"
create_route "route_genob_msautoprinting_service" "/msautoprinting/service"
create_route "route_genob_MSIG_PortalWS_jaxrs_AttachDoc" "/MSIG_PortalWS/jaxrs/AttachDoc"
create_route "route_genob_MSIG_PortalWS_jaxrs_Bringup" "/MSIG_PortalWS/jaxrs/Bringup"
create_route "route_genob_MSIG_PortalWS_jaxrs_CaseMgmt" "/MSIG_PortalWS/jaxrs/CaseMgmt"
create_route "route_genob_MSIG_PortalWS_jaxrs_ClientDoc" "/MSIG_PortalWS/jaxrs/ClientDoc"
create_route "route_genob_MSIG_PortalWS_jaxrs_Mail" "/MSIG_PortalWS/jaxrs/Mail"
create_route "route_genob_MSIG_PortalWS_jaxrs_Noti" "/MSIG_PortalWS/jaxrs/Noti"
create_route "route_genob_MSIG_PortalWS_jaxrs_Policy" "/MSIG_PortalWS/jaxrs/Policy"
create_route "route_genob_MSIG_PortalWS_jaxrs_SMS" "/MSIG_PortalWS/jaxrs/SMS"
create_route "route_genob_MSIG_GenlinkWS_jaxrs_AccountRS" "/MSIG_GenlinkWS/jaxrs/AccountRS"
create_route "route_genob_MSIG_GenlinkWS_jaxrs_GenlinkRS" "/MSIG_GenlinkWS/jaxrs/GenlinkRS"
create_route "route_genob_MSIG_GenlinkWS_jaxrs_GenlinkTARS" "/MSIG_GenlinkWS/jaxrs/GenlinkTARS"
create_route "route_genob_MSIG_ReportWS_jaxrs_PdfReport" "/MSIG_ReportWS/jaxrs/PdfReport"
create_route "route_genob_api" "/api"
create_route "route_genob_renew" "/renew"
create_route "route_genob_bailbond" "/bailbond"
create_route "route_genob_account" "/account"
create_route "route_genob_rest_printing_copyPolicy" "/rest/printing/copyPolicy"
create_route "route_genob_rest" "/rest"
create_route "route_genob_motor" "/motor"
create_route "route_genob_rest_manualvideo" "/rest/manualvideo"
create_route "route_genob_agent_master" "/agent/master"
create_route "route_genob_agent_mail" "/agent/mail"
create_route "route_genob_agent_cmi" "/agent/cmi"
create_route "route_genob_agent" "/agent"
create_route "route_genob_onlineCode" "/onlineCode"
create_route "route_genob_master" "/master"
create_route "route_genob_landingPage" "/landingPage"
create_route "route_genob_home" "/home"
create_route "route_genob_attachment" "/attachment"
create_route "route_genob_travel_oversea" "/travel/oversea"
create_route "route_genob_travel_domestic" "/travel/domestic"
create_route "route_genob_travel_agreement_oversea" "/travel/agreement/oversea"
create_route "route_genob_travel_agreement" "/travel/agreement"
create_route "route_genob_travel" "/travel"
create_route "route_genob_inbound" "/inbound"
create_route "route_genob_seasonal" "/seasonal"
create_route "route_genob_request_cmi" "/request/cmi"
create_route "route_genob_request" "/request"
create_route "route_genob_loan" "/loan"
create_route "route_genob_MSIG_ACWS_rest_datatable" "/MSIG_ACWS/rest/datatable"
create_route "route_genob_MSIG_ACWS_rest_auth" "/MSIG_ACWS/rest/auth"

echo "Service and routes created successfully!"

