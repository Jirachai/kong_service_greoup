#!/bin/bash

# Set your Kong Admin API URL and authentication token
KONG_ADMIN="http://127.0.0.1:8001"
KONG_ADMIN_TOKEN="<your-token>"
WORK_SPACE="default"

# Service details
SERVICE_NAME="svc_service"
SERVICE_URL="thd-liberty.th.msig.com_25066"
SERVICE_TAGS='["prod", "service"]'

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
  ROUTE_TAGS='["prod", "service"]'

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
create_route "route_service_rest_convertPdf" "/rest/convertPdf"
create_route "route_service_rest_reductPdf" "/rest/reductPdf"
create_route "route_service_rest_RunningGenerator" "/rest/RunningGenerator"
create_route "route_service_rest_EmailService_emailService" "/rest/EmailService/emailService"
create_route "route_service_rest_PMIService" "/rest/PMIService"
create_route "route_service_rest_TaxReg" "/rest/TaxReg"
create_route "route_service_rest_BizSmart" "/rest/BizSmart"
create_route "route_service_rest_otpservice" "/rest/otpservice"
create_route "route_service_rest_ThaiVietjetService" "/rest/ThaiVietjetService"
create_route "route_service_rest_ssquare" "/rest/ssquare"
create_route "route_service_api_pv" "/api/pv"
create_route "route_service_api" "/api"
create_route "route_service_clientchecking" "/clientchecking"
create_route "route_service_rest_AgentService" "/rest/AgentService"
create_route "route_service_rest_buckets" "/rest/buckets"
create_route "route_service_msautoprinting_service" "/msautoprinting/service"
create_route "route_service_MSIG_PortalWS_jaxrs_AttachDoc" "/MSIG_PortalWS/jaxrs/AttachDoc"
create_route "route_service_MSIG_PortalWS_jaxrs_Bringup" "/MSIG_PortalWS/jaxrs/Bringup"
create_route "route_service_MSIG_PortalWS_jaxrs_CaseMgmt" "/MSIG_PortalWS/jaxrs/CaseMgmt"
create_route "route_service_MSIG_PortalWS_jaxrs_ClientDoc" "/MSIG_PortalWS/jaxrs/ClientDoc"
create_route "route_service_MSIG_PortalWS_jaxrs_CodeDesc" "/MSIG_PortalWS/jaxrs/CodeDesc"
create_route "route_service_MSIG_PortalWS_jaxrs_DocControl" "/MSIG_PortalWS/jaxrs/DocControl"
create_route "route_service_MSIG_PortalWS_jaxrs_Mail" "/MSIG_PortalWS/jaxrs/Mail"
create_route "route_service_MSIG_PortalWS_jaxrs_Noti" "/MSIG_PortalWS/jaxrs/Noti"
create_route "route_service_MSIG_PortalWS_jaxrs_Policy" "/MSIG_PortalWS/jaxrs/Policy"
create_route "route_service_printingQueue_api_printing" "/printingQueue/api/printing"
create_route "route_service_MSIG_GenlinkWS_jaxrs_AccountRS" "/MSIG_GenlinkWS/jaxrs/AccountRS"
create_route "route_service_MSIG_GenlinkWS_jaxrs_GenlinkRS" "/MSIG_GenlinkWS/jaxrs/GenlinkRS"
create_route "route_service_MSIG_GenlinkWS_jaxrs_GenlinkTARS" "/MSIG_GenlinkWS/jaxrs/GenlinkTARS"
create_route "route_service_MSIG_IAppWeb" "/MSIG_IAppWeb"
create_route "route_service_MSIG_ReportWS_jaxrs_PdfReport" "/MSIG_ReportWS/jaxrs/PdfReport"
create_route "route_service_auth2" "/auth2"
create_route "route_service_api" "/api"
create_route "route_service_renew_person_accident" "/renew/person/accident"
create_route "route_service_renew_motor" "/renew/motor"
create_route "route_service_renew_information" "/renew/information"
create_route "route_service_bailbond" "/bailbond"
create_route "route_service_account_payment" "/account/payment"
create_route "route_service_account" "/account"
create_route "route_service_rest" "/rest"
create_route "route_service_person_accident" "/person/accident"
create_route "route_service_agent_master" "/agent/master"
create_route "route_service_agent_mail" "/agent/mail"
create_route "route_service_agent_client" "/agent/client"
create_route "route_service_workQueue" "/workQueue"
create_route "route_service_user" "/user"
create_route "route_service_onlineCode" "/onlineCode"
create_route "route_service_master" "/master"
create_route "route_service_landingPage" "/landingPage"
create_route "route_service_agent" "/agent"
create_route "route_service_home" "/home"
create_route "route_service_attachment" "/attachment"
create_route "route_service_travel_oversea" "/travel/oversea"
create_route "route_service_travel_domestic" "/travel/domestic"
create_route "route_service_travel" "/travel"
create_route "route_service_inbound" "/inbound"
create_route "route_service_seasonal" "/seasonal"
create_route "route_service_request_survey" "/request/survey"
create_route "route_service_request_quote" "/request/quote"
create_route "route_service_request_cmi" "/request/cmi"
create_route "route_service_request" "/request"
create_route "route_service_quote" "/quote"
create_route "route_service_dashboard_daily" "/dashboard/daily"
create_route "route_service_dashboard" "/dashboard"
create_route "route_service_loan" "/loan"
create_route "route_service_rest_datatable" "/rest/datatable"
create_route "route_service_rest_auth" "/rest/auth"
create_route "route_service_rest" "/rest"

echo "Service and routes created successfully!"

