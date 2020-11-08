# See all canaries
kubectl get canaries --all-namespaces

# Use this filter in Kiali (hide field)
app!*=canary and app!=istio-ingressgateway