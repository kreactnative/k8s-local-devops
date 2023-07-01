#### enable master
```
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

```
#### delete kube-proxy
```
kubectl -n kube-system delete ds kube-proxy
kubectl -n kube-system delete cm kube-proxy
```
#### install cilium cni
```
helm repo add cilium https://helm.cilium.io/
helm repo update cilium

helm upgrade --install cilium cilium/cilium \
    --namespace kube-system \
    --set bpf.masquerade=true \
    --set encryption.nodeEncryption=false \
    --set k8sServiceHost=192.168.1.26 \
    --set k8sServicePort=6443  \
    --set kubeProxyReplacement=strict  \
    --set operator.replicas=1  \
    --set serviceAccounts.cilium.name=cilium  \
    --set serviceAccounts.operator.name=cilium-operator  \
    --set tunnel=vxlan \
    --set hubble.enabled=true \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set prometheus.enabled=true \
    --set operator.prometheus.enabled=true \
    --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}"
```