#### #### #### #### #### #### #### ####  
#### Run this scriot on Worker node. #### 
#### #### #### #### #### #### #### ####  

#!/bin/bash


cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


# Install CRI-O and Kubernetes dependencies
yum install -y  vim git screen ntp curl wget yum-utils device-mapper-persistent-data lvm2

OS=CentOS_7
VERSION=1.26
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/devel:kubic:libcontainers:stable.repo
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo

yum install -y cri-o kubeadm-1.26.3 kubectl-1.26.3 kubelet-1.26.3


# Configuring sysctl....
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system


# Enable and start CRI-O and kubelet services
systemctl enable crio && systemctl start crio
systemctl enable kubelet && systemctl start kubelet


# Disabling Firewall if enabled
sudo systemctl disable --now firewalld
