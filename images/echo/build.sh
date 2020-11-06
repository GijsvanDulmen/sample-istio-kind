#!/usr/bin/env bash
docker build -t gijsvandulmen/echoserver:latest .
docker push gijsvandulmen/echoserver:latest
