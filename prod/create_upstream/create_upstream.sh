#!/bin/bash

# Set your Kong Admin API URL
KONG_ADMIN_URL="http://localhost:8001"

# Define the upstream list properly
UPSTREAMS=(
    "thd-liberty.th.msig.com:10001"
    "thd-liberty.th.msig.com:10002"
    "thd-liberty.th.msig.com:10004"
    "thd-liberty.th.msig.com:10008"
    "thd-liberty.th.msig.com:10011"
    "thd-liberty.th.msig.com:10013"
    "thd-liberty.th.msig.com:10014"
    "thd-liberty.th.msig.com:10015"
    "thd-liberty.th.msig.com:10017"
    "thd-liberty.th.msig.com:10018"
    "thd-liberty.th.msig.com:10019"
    "thd-liberty.th.msig.com:10022"
    "thd-liberty.th.msig.com:10034"
    "thd-liberty.th.msig.com:10077"
    "thd-liberty.th.msig.com:10084"
    "thd-liberty.th.msig.com:10088"
    "thd-liberty.th.msig.com:10089"
    "thd-liberty.th.msig.com:10093"
    "thd-liberty.th.msig.com:10097"
    "thd-liberty.th.msig.com:10100"
    "thd-liberty.th.msig.com:10107"
    "thd-liberty.th.msig.com:10108"
    "thd-liberty.th.msig.com:10110"
    "thd-liberty.th.msig.com:11889"
    "thd-liberty.th.msig.com:12867"
    "thd-mservicept0:10101"
    "thd-mservicept0.th.msig.com:10096"
    "thd-mservicept0.th.msig.com:10098"
    "thd-mservicept0.th.msig.com:10099"
    "thd-mservicept0.th.msig.com:10100"
    "thd-mservicept0.th.msig.com:10116"
    "thd-portal.th.msig.com:10039"
    "thd-printft-pt.th.msig.com:10117"
    "thd-was.th.msig.com"
    "thd-mservicept0.th.msig.com:10106"
    "thd-liberty.th.msig.com:25998"
    "thd-liberty.th.msig.com:25081"
    "thd-liberty.th.msig.com:25066"
    "thd-liberty.th.msig.com:25063"
    "thd-liberty.th.msig.com:25062"
    "thd-liberty.th.msig.com:25061"
    "thd-liberty.th.msig.com:25060"
    "thd-liberty.th.msig.com:25059"
    "thd-liberty.th.msig.com:25058"
    "thd-liberty.th.msig.com:25057"
    "thd-liberty.th.msig.com:25056"
    "thd-liberty.th.msig.com:25053"
    "thd-liberty.th.msig.com:25052"
    "thd-liberty.th.msig.com:25020"
    "thd-liberty.th.msig.com:25000"
    "thd-jboss1.th.msig.com"
)

# Loop through the list and create upstreams
for UPSTREAM in "${UPSTREAMS[@]}"; do
    # Extract hostname and port
    HOST=$(echo "$UPSTREAM" | cut -d':' -f1)
    PORT=$(echo "$UPSTREAM" | cut -d':' -f2)

    # Create an upstream in Kong
    echo "Creating upstream: $HOST"
    curl -s -X POST "$KONG_ADMIN_URL/upstreams" \
        -H "Content-Type: application/json" \
        -d "{\"name\": \"$HOST\"}"

    # Add target (backend instance) to the upstream
    if [ -n "$PORT" ]; then
        echo "Adding target $UPSTREAM to upstream: $HOST"
        curl -s -X POST "$KONG_ADMIN_URL/upstreams/$HOST/targets" \
            -H "Content-Type: application/json" \
            -d "{\"target\": \"$UPSTREAM\"}"
    fi
done

echo "Upstreams and targets created successfully!"

