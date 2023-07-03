kubectl apply -f metrics-server.yaml -n kube-system
kubectl create ns metallb-system
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f metallb.yaml
sed -i ''  -e 's/$IP/192.168.1.18/' configmap.yaml
sed -i ''  -e 's/$IP/192.168.1.18/' configmap.yaml
kubectl apply -f configmap.yaml
istioctl install -f istio-operater-http3.yaml -y
mkcert '*.local.k8s.com'
kubectl -n istio-system create secret tls local-k8s-cred --key=_wildcard.local.k8s.com-key.pem --cert=_wildcard.local.k8s.com.pem
mkcert --install
kubectl apply -f local-k8s-gateway.yaml -n istio-system
kubectl apply -f hubble-ui-vs.yaml -n kube-system
sudo sh -c "echo '192.168.1.18 hubble-ui.local.k8s.com' > /etc/hosts"
curl -i https://hubble-ui.local.k8s.com
rm -rf *.pem
open https://hubble-ui.local.k8s.com