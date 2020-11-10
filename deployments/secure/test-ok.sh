#!/bin/sh
# TOKEN=$(cat jwt-with-groups.txt) && echo "$TOKEN" | cut -d '.' -f2 - | base64 --decode -
TOKEN=$(cat jwt-with-groups.txt)

if [ -x "$(command -v http)" ]; then
    http --print=Hh GET localhost/secure Authorization:"Bearer $TOKEN"
else
    curl "http://localhost/secure" -v -o /dev/null -H "Authorization: Bearer $TOKEN"
fi