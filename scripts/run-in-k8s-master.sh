nmcli con mod "$NETWORK_NAME" ipv4.address "$IP/24"
nmcli con mod "$NETWORK_NAME" ipv4.gateway "192.168.1.1"
nmcli con mod "$NETWORK_NAME" ipv4.method "manual"

sudo hostnamectl set-hostname $HOSTNAME
sudo timedatectl set-timezone Asia/Bangkok
echo $IP  $HOSTNAME >> /etc/hosts
sudo timedatectl set-timezone Asia/Bangkok
dnf makecache --refresh
dnf update --allowerasing --skip-broken --nobest  -y
cat /etc/rocky-release
uname -r
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

modprobe overlay
modprobe br_netfilter

cat > /etc/modules-load.d/k8s.conf << EOF
overlay
br_netfilter
EOF

cat > /etc/sysctl.d/k8s.conf << EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding=1
EOF

sudo sysctl -w net.ipv6.conf.all.forwarding=1
echo net.ipv6.conf.all.forwarding=1 >> /etc/sysctl.conf

sysctl --system

swapoff -a
sed -e '/swap/s/^/#/g' -i /etc/fstab
free -m


dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf makecache
dnf install -y containerd.io

mv /etc/containerd/config.toml /etc/containerd/config.toml.orig
containerd config default > /etc/containerd/config.toml
sed -i "s|SystemdCgroup = false|SystemdCgroup = true|g" /etc/containerd/config.toml


systemctl enable --now containerd.service
systemctl status containerd.service


cat > /etc/yum.repos.d/k8s.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF


dnf makecache
dnf install -y {kubelet,kubeadm,kubectl} --disableexcludes=kubernetes
systemctl enable --now kubelet.service
systemctl status kubelet

sudo dnf install yum-plugin-versionlock -y
sudo dnf versionlock kubelet kubeadm kubectl

mkdir /opt/bin
curl -fsSLo /opt/bin/flanneld https://github.com/flannel-io/flannel/releases/download/v0.20.1/flannel-v0.20.1-linux-amd64.tar.gz
chmod +x /opt/bin/flanneld


sudo dnf install cockpit -y
sudo systemctl enable --now cockpit.socket


sudo dnf install cockpit-podman  -y
sudo dnf install cockpit-storaged  -y
sudo dnf install cockpit-networkmanager  -y

sudo dnf install nfs-utils nfs4-acl-tools -y
sudo systemctl start nfs-client.target
sudo systemctl enable nfs-client.target
sudo systemctl status nfs-client.target

sudo dnf install nmap  -y

kubeadm init
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl -n kube-system delete ds kube-proxy
kubectl -n kube-system delete cm kube-proxy

kubectl taint nodes --all node-role.kubernetes.io/control-plane-


curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
cp /usr/local/bin/helm /usr/bin/helm

helm repo add cilium https://helm.cilium.io/
helm upgrade --install cilium cilium/cilium \
    --namespace kube-system \
    --set bpf.masquerade=true \
    --set encryption.nodeEncryption=false \
    --set k8sServiceHost=$IP \
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


sudo systemctl stop firewalld
sudo systemctl disable firewalld
cat $HOME/.kube/config