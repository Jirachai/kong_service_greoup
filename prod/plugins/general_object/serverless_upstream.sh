#!/bin/bash

# Kong Admin API URL
KONG_ADMIN="http://localhost:8001"
KONG_ADMIN_TOKEN="<>"

# Service Name
SERVICE_NAME="svc_general_object"

# Serverless Function Logic
SERVERLESS_FUNCTION=$(cat <<EOF
local path = kong.request.get_path()

local upstreams = {
    ["/rest/registerEMail"] = "thd-liberty.th.msig.com_10008",
    ["/rest/PrintingService"] = "thd-liberty.th.msig.com_10018",
    ["/rest/otpservice"] = "thd-liberty.th.msig.com_10084",
    ["/api/repair/"] = "thd-liberty.th.msig.com_10108",
    ["/api/report/"] = "thd-liberty.th.msig.com_10108",
    ["/rest/logcenter"] = "thd-mservicept0.th.msig.com_10096",
    ["/rest/logsms"] = "thd-mservicept0.th.msig.com_10096",
    ["/msautoprinting/service/"] = "thd-mservicept0.th.msig.com_10116",
    ["/MSIG_PortalWS/jaxrs/AttachDoc"] = "thd-portal.th.msig.com_10039",
    ["/MSIG_PortalWS/jaxrs/Bringup"] = "thd-portal.th.msig.com_10039",
    ["/MSIG_PortalWS/jaxrs/CaseMgmt"] = "thd-portal.th.msig.com_10039",
    ["/MSIG_PortalWS/jaxrs/ClientDoc"] = "thd-portal.th.msig.com_10039",
    ["/MSIG_PortalWS/jaxrs/Mail"] = "thd-portal.th.msig.com_10039",
    ["/MSIG_PortalWS/jaxrs/Noti"] = "thd-portal.th.msig.com_10039",
    ["/MSIG_PortalWS/jaxrs/Policy"] = "thd-portal.th.msig.com_10039",
    ["/MSIG_PortalWS/jaxrs/SMS"] = "thd-portal.th.msig.com_10039",
    ["/MSIG_GenlinkWS/jaxrs/AccountRS"] = "thd-was.th.msig.com",
    ["/MSIG_GenlinkWS/jaxrs/GenlinkRS"] = "thd-was.th.msig.com",
    ["/MSIG_GenlinkWS/jaxrs/GenlinkTARS"] = "thd-was.th.msig.com",
    ["/MSIG_ReportWS/jaxrs/PdfReport"] = "thd-was.th.msig.com",
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

curl -i -X POST "$KONG_ADMIN/$WORKSPACE/services/$SERVICE_NAME/plugins" \
  -H "Kong-Admin-Token: $KONG_ADMIN_TOKEN" \
  --data "name=pre-function" \
  --data-urlencode "config.access=$SERVERLESS_FUNCTION"

echo "Serverless function plugin applied successfully!"

