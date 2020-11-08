#!/bin/sh
curl "http://localhost/secure" -v -H "Authorization: Bearer invalidToken"