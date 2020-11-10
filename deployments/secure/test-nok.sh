#!/bin/sh
curl "http://localhost/secure" -v -o /dev/null -H "Authorization: Bearer invalidToken"