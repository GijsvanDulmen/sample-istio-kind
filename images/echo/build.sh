#!/usr/bin/env bash
docker build -t gijsvandulmen/echoserver:latest .
docker push gijsvandulmen/echoserver:latest

# extra tag for flagger deployments
docker tag gijsvandulmen/echoserver:latest gijsvandulmen/echoserver:v9