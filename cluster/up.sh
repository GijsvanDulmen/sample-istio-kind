#!/bin/bash

set -e exit

kind create cluster --name kind01 --config kind-config.yml
kubectl cluster-info --context kind-kind01

# show
kubectl get pods --all-namespaces

# OPTIONAL: install dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
echo "Use following token for k8s dashboard"
echo $(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)

# sleep a bit
sleep 10

# download istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.6.3 sh -
export PATH=$PWD/istio-1.6.3/bin:$PATH

kubectl create namespace istio-system
kubectl apply -f kiali-secret.yml

# install istio
istioctl install \
    --set values.meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY \
    --set values.meshConfig.accessLogFile="/dev/stdout" \
    --set values.gateways.istio-ingressgateway.loadBalancerIP=127.0.0.100 \
    --set values.tracing.enabled=true \
    --set values.kiali.enabled=true \
    --set values.global.jwtPolicy=first-party-jwt

# enable injection on default
kubectl label namespace default istio-injection=enabled

sleep 10

# make sure TLS is on by default
kubectl get configmap istio -n istio-system -o yaml | sed 's/enableAutoMtls: false/enableAutoMtls: true/g' | kubectl replace -n istio-system -f -

# Install metallb
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
kubectl create -f ./metallb-config.yaml

# Open up something
cd ../deployments
./install.sh

# kubectl get pods --all-namespaces