### local Devops
#### feature
```
- k8s
- istio gateway
- local domain/gitlab/registry site/hubble-ui
    - https://gitlab.local.k8s.com
    - https://registry.local.k8s.com
    - https://hubble-ui.local.k8s.com
- local gitlab runner
- test cicd
```
#### spec
```
macos
parallels desktop
```

#### install kubectl
```
brew install kubectl
```
#### install istioctl
- [istioctl](https://istio.io/latest/docs/ops/diagnostic-tools/istioctl/)
#### install helm
```
brew install helm
```
#### install cilium-cli
```
brew install cilium-cli
```
#### install ktail
```
brew tap atombender/ktail
brew install atombender/ktail/ktail
```
#### install mkcert
```
brew install mkcert
brew install nss
```
#### tutorials
```
1.create vm (parallel desktop)
2.install k8s
3.install k8s network
4.install k8s metrics server
5.install k8s metal-lb load balancer
6.install k8s istio
7.create/install local ssl
8.create-k8s-istio-gateway-site
9.install gitlab/registry (docker)
9-1.install k8s gitlab runner
9-2.test gitlab runner
```