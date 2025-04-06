#!/bin/bash

# Set Kong Admin API URL
KONG_ADMIN_URL="http://localhost:8001"
WORK_SPACE="default"
KONG_ADMIN_TOKEN=""

# Define the upstream name and target pairs
UPSTREAMS=(
  "th-ngenlink1.th.msig.com:10001"
  "th-ngenlink1.th.msig.com:10002"
  "th-ngenlink1.th.msig.com:10004"
  "th-ngenlink1.th.msig.com:10008"
  "th-microservice.th.msig.com:10011"
  "th-ngenlink1.th.msig.com:10014"
  "th-microservice.th.msig.com:10017"
  "thd-liberty.th.msig.com:10018"
  "th-ngenlink1.th.msig.com:10019"
  "thd-liberty.th.msig.com:10034"
  "th-microservice.th.msig.com:10077"
  "th-microservice.th.msig.com:10084"
  "th-msbatch.th.msig.com:10088"
  "th-microservice.th.msig.com:10089"
  "th-microservice.th.msig.com:10093"
  "th-microservice.th.msig.com:10097"
  "th-microservice.th.msig.com:10100"
  "th-microservice.th.msig.com:10107"
  "th-microservice.th.msig.com:10108"
  "th-microservice.th.msig.com:10110"
  "th-microservice.th.msig.com:11889"
  "th-ngenlink1.th.msig.com:12867"
  "th-mservicept00.th.msig.com:10101"
  "th-mservicept00.th.msig.com:10096"
  "th-mservicept00.th.msig.com:10100"
  "th-mservicept00.th.msig.com:10116"
  "th-wps.th.msig.com:10039"
  "th-printft-pt.th.msig.com:10117"
  "th-was.th.msig.com:80"
  "th-mservicept00.th.msig.com:10106"
  "th-msbatch.th.msig.com:25998"
  "th-ngenlink1.th.msig.com:25054"
  "th-ngenlink1.th.msig.com:25066"
  "th-ngenlink1.th.msig.com:25063"
  "th-ngenlink1.th.msig.com:25062"
  "th-ngenlink1.th.msig.com:25061"
  "th-ngenlink1.th.msig.com:25060"
  "th-ngenlink1.th.msig.com:25059"
  "th-ngenlink1.th.msig.com:25058"
  "th-ngenlink1.th.msig.com:25057"
  "th-ngenlink1.th.msig.com:25056"
  "th-ngenlink1.th.msig.com:25053"
  "th-ngenlink1.th.msig.com:25052"
  "th-ngenlink1.th.msig.com:25020"
  "th-ngenlink1.th.msig.com:25000"
  "th-jboss.th.msig.com:80"
)

# Loop through each upstream pair and create in Kong
for entry in "${UPSTREAMS[@]}"; do
  NAME=$(echo "$entry" | sed 's/:/_/g')
  TARGET=$entry
  HOST=$(echo $entry | cut -d ':' -f 1)
  PORT=$(echo $entry | cut -d ':' -f 2)

  if ! [[ "$PORT" =~ ^[1-9]+$ ]]; then
    PORT=80
    TARGET=$TARGET:$PORT
  fi

  echo "Creating upstream: $NAME"
  curl -s -X POST "$KONG_ADMIN_URL/$WORK_SPACE/upstreams" \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token: $KONG_ADMIN_TOKEN" \
    -d "{\"name\": \"$NAME\", \"tags\": [\"host=$HOST\", \"port=$PORT\"]}"

  echo "Adding target $TARGET to upstream: $NAME"
  curl -s -X POST "$KONG_ADMIN_URL/$WORK_SPACE/upstreams/$NAME/targets" \
    -H "Content-Type: application/json" \
    -H "Kong-Admin-Token: $KONG_ADMIN_TOKEN" \
    -d "{\"target\": \"$TARGET\"}"

done

echo "Upstreams and targets created successfully!"

