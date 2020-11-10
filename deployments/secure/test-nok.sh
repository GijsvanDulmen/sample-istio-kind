#!/bin/sh
if [ -x "$(command -v http)" ]; then
    http -v GET localhost/secure Authorization:"Bearer NOTVALID"
else
    curl "http://localhost/secure" -v -o /dev/null -H "Authorization: Bearer NOTVALID"
fi