#/bin/bash

curl -X POST http://127.0.0.1:8001/services \
     -H "Kong-Admin-Token: <your-token>" \
     -H "Content-Type: application/json" \
     -d '{
           "name": "svc_finance",
           "url": "http://thd-liberty.th.msig.com:10002",
           "routes": [
             {
               "name": "route_rest_payment_2c2p",
               "paths": ["/rest/payment/2c2p"],
               "methods": ["GET", "POST"],
	       "strip_path": false
             },
             {
               "name": "route_rest_payment_quickpay",
               "paths": ["/rest/payment/quickpay"],
               "methods": ["GET", "POST"],
	       "strip_path": false
             }
           ]
         }'

