#### install k8s gitlab runner
```
helm repo add gitlab https://charts.gitlab.io
helm repo update gitlab
helm upgrade --install --namespace gitlab-runner gitlab-runner -f runner.yaml gitlab/gitlab-runner --create-namespace --version 0.52.0

kubectl create secret docker-registry docker-registry-credentials --docker-server=https://registry.local.k8s.com --docker-username=root --docker-password=glpat-qJj5yqqdaYKQDYuxaeu3 --docker-email=dotnetnat@gmail.com -n gitlab-runner
```