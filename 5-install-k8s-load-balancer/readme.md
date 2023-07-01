#### install metal-lb
```
kubectl create ns metallb-system
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f metalllb.yaml
kubectl apply -f configmap.yaml
```