#### install gitlab/registry (docker)
```
sudo dnf check-update
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $(whoami)

sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-compose-plugin

cd /opt
mkdir gitlab
cd gitlab
vi docker-compose.yml

docker compose up -d
```
#### get default root password
```
docker exec -it gitlab-ce cat /etc/gitlab/initial_root_password
```
#### map gitlab/registry to k8s istio
```
kubectl create ns gitlab
kubectl apply -f gitlab-vs-endpoint.yaml -n gitlab
kubectl apply -f registry-vs-endpoint.yaml -n gitlab
```