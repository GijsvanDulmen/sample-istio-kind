#!/bin/bash
POD=$(kubectl -n istio-system get pod -l app=istio-ingressgateway -o jsonpath="{.items[0].metadata.name}")
kubectl -n istio-system port-forward ${POD} 8080 &
cd ../traphic-generator
# works on osx:

KIALIPOD=$(kubectl -n istio-system get pod -l app=kiali -o jsonpath="{.items[0].metadata.name}")
kubectl -n istio-system port-forward ${KIALIPOD} 20001 &
open http://localhost:20001/kiali/console/graph/namespaces/\?edges\=requestsPerSecond\&graphType\=versionedApp\&namespaces\=default%2Cistio-system\&unusedNodes\=false\&operationNodes\=false\&injectServiceNodes\=true\&duration\=60\&refresh\=15000\&layout\=dagre
# could be used otherwise
# ../cluster/istio-1.7.4/bin/istioctl dashboard kiali &
node index.js