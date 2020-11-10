#!/bin/sh
echo ""
echo "BEARER TOKEN: "
TOKEN=$(cat jwt-with-groups.txt) && echo "$TOKEN" | cut -d '.' -f2 - | base64 --decode -

echo ""
echo ""
echo "HTTP STATUS CODE RESULT: "
curl "http://localhost/secure" -v -o /dev/null -H "Authorization: Bearer $TOKEN"