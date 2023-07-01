#### create istio gateway
```
kubectl apply -f local-k8s-gateway.yaml -n istio-system
```

#### create example site virtual service
```
kubectl apply -f hubble-ui-vs.yaml -n kube-system
```