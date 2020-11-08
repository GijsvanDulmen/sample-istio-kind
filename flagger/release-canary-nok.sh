#!/bin/bash

# Example with update of the container image
# if kubectl get deployment canary -o=jsonpath='{$.spec.template.spec.containers[:1].image}' | grep -q ':latest'; then
#     kubectl -n default set image deployment/canary canary=gijsvandulmen/fixed:v9
# else
#     kubectl -n default set image deployment/canary canary=gijsvandulmen/fixed:latest
# fi

kubectl set env deployment/canary STATUS_CODE="500"

# wait for Flagger to detect the change
ok=false
until ${ok}; do
    kubectl get canary/canary | grep 'Progressing' && ok=true || ok=false
    sleep 5
done

# wait for the canary analysis to finish
kubectl wait canary/canary --for=condition=promoted --timeout=5m

# check if the deployment was successful 
kubectl get canary/canary | grep Succeeded