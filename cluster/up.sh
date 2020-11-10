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

echo "Installing Istio Operator"
istioctl operator init
kubectl -n istio-operator wait --for=condition=available --timeout=600s deployment/istio-operator

echo "Installing istio Controlplane"
kubectl apply -f istio.yml
sleep 20 # needed to let the operator pick up the configuration
kubectl -n istio-system wait --for=condition=available --timeout=600s deployment/istiod

echo "Installing prometheus"
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/prometheus.yaml || :

# as of 10 november this is kiali 1.26 (relatively latest)
echo "Installing kiali"
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/kiali.yaml || :
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/kiali.yaml || :

# patch
kubectl -n istio-system patch svc kiali --patch '{"spec": { "type": "NodePort", "ports": [ { "name": "http", "nodePort": 30123, "port": 20001, "protocol": "TCP", "targetPort": 20001 }, { "name": "http-metrics", "nodePort": 30333, "port": 9090, "protocol": "TCP", "targetPort": 9090 } ] } }'

echo "Installing flagger"
kubectl apply -k github.com/weaveworks/flagger//kustomize/istio

# wait for everything to be available
kubectl -n istio-system wait --for=condition=available --timeout=600s deployment/prometheus
kubectl -n istio-system wait --for=condition=available --timeout=600s deployment/kiali
kubectl -n istio-system wait --for=condition=available --timeout=600s deployment/flagger

# enable injection on default
kubectl label namespace default istio-injection=enabled

sleep 2

# install flagger stuff
kubectl apply -f ../flagger/deployment.yml
kubectl apply -f ../flagger/canary.yml

# make sure TLS is on by default
# already on by default on 1.7.4
# kubectl get configmap istio -n istio-system -o yaml | sed 's/enableAutoMtls: false/enableAutoMtls: true/g' | kubectl replace -n istio-system -f -

# Open up something
cd ../deployments
./install.sh

# kubectl get pods --all-namespaces