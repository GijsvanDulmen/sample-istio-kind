#!/bin/bash
kubectl apply -k ./overlays/v1
kubectl apply -k ./overlays/v2
kubectl apply -k ./overlays/v3
kubectl apply -k ./overlays/v4
kubectl apply -k ./overlays/v5