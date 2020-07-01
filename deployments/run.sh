#!/bin/bash
POD=$(kubectl -n istio-system get pod -l app=istio-ingressgateway -o jsonpath="{.items[0].metadata.name}")
kubectl -n istio-system port-forward ${POD} 8080 &
cd ../traphic-generator
../cluster/istio-1.6.3/bin/istioctl dashboard kiali &
node index.js