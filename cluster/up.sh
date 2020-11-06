#!/bin/bash

set -e exit

kind create cluster --name kind01 --config kind-config.yml
kubectl cluster-info --context kind-kind01

# show
kubectl get pods --all-namespaces

# OPTIONAL: install dashboard
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
# kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
# echo "Use following token for k8s dashboard"
# echo $(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)
# sleep a bit
# sleep 10

# download istio if not already downloaded
if [ ! -d "./istio-1.7.4" ] 
then
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.7.4 sh -
fi
export PATH=$PWD/istio-1.7.4/bin:$PATH

kubectl create namespace istio-system
kubectl apply -f kiali-secret.yml

# install istio
istioctl operator init

kubectl apply -f istio.yml

# install prometheus
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/prometheus.yaml

sleep 5

# install kiali 1.26 (relatively latest)
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/kiali.yaml

sleep 5

# enable injection on default
kubectl label namespace default istio-injection=enabled

sleep 10

# make sure TLS is on by default
# already on by default on 1.7.4
# kubectl get configmap istio -n istio-system -o yaml | sed 's/enableAutoMtls: false/enableAutoMtls: true/g' | kubectl replace -n istio-system -f -

# Install metallb
# kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
# kubectl create -f ./metallb-config.yaml

# Open up something
cd ../deployments
./install.sh

# kubectl get pods --all-namespaces