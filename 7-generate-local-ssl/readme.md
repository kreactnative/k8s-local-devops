#### generate ssl local by mkcert
```
mkcert '*.local.k8s.com'
```
#### create k8s secret ssl
```
kubectl -n istio-system create secret tls local-k8s-cred --key=_wildcard.local.k8s.com-key.pem --cert=_wildcard.local.k8s.com.pem
```
#### trust local cert
```
mkcert --install
```