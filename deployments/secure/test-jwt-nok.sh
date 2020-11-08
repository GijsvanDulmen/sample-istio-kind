#!/bin/sh
echo ""
echo "BEARER TOKEN: "
TOKEN=$(cat jwt-without-groups.txt) && echo "$TOKEN" | cut -d '.' -f2 - | base64 --decode -

echo ""
echo ""
echo "HTTP STATUS CODE RESULT: "
curl "http://localhost/secure" -s -o /dev/null -H "Authorization: Bearer $TOKEN" -w "%{http_code}\n"