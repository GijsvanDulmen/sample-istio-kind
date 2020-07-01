#!/bin/bash
kubectl apply -k ./overlays/v1
kubectl apply -k ./overlays/v2
kubectl apply -f ./virtualservice.yml