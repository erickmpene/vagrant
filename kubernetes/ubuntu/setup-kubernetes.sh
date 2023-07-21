#!/bin/bash
# kubeadm installation instructions as on
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# this script supports Ubuntu 20.04 LTS and later only
# run this script with sudo
apt update 
apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https ntp git 

if ! [ $USER = root ]
then
	echo run this script with sudo
	exit 3
fi

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

if [ $MYOS = "Ubuntu" ]
then
	echo "################## RUNNING UBUNTU CONFIG #############"
	echo "######################################################"
	sudo swapoff -a
	sudo sed -i 's/\/swap/#\/swap/' /etc/fstab
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
	echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
	
	echo "############ IPTABLE CONFIGURRATION  ##############"
	echo "###################################################"
	cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
	sudo modprobe overlay
	sudo modprobe br_netfilter
	cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

	sudo sysctl --system

	sudo apt update

	echo "########## CONTAINERD INSTALLATION AND CONFIGURATION ########################"
	echo "#############################################################################"
	wget https://github.com/containerd/containerd/releases/download/v1.6.8/containerd-1.6.8-linux-amd64.tar.gz
	sudo tar Cxzvf /usr/local containerd-1.6.8-linux-amd64.tar.gz
	wget https://github.com/opencontainers/runc/releases/download/v1.1.3/runc.amd64
	sudo install -m 755 runc.amd64 /usr/local/sbin/runc
	wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
	sudo mkdir -p /opt/cni/bin
	sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz
	sudo mkdir /etc/containerd
	containerd config default | sudo tee /etc/containerd/config.toml
	sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
	sudo curl -L https://raw.githubusercontent.com/containerd/containerd/main/containerd.service -o /etc/systemd/system/containerd.service
	sudo systemctl daemon-reload
	sudo systemctl enable --now containerd
	sudo systemctl start containerd

	echo "################### INSTALLATION OF KUBEADM + KUBECTL + KUBELET ####################### "
	echo "#######################################################################################"
	sudo apt install -y kubeadm kubectl kubelet

	kubectl version --client

	sudo apt-mark hold kubeadm kubectl kubelet

	echo "############ INITIALISATION OF KUBERNETES CLUSTER ###############"
	echo "#################################################################"
	sudo kubeadm init --pod-network-cidr=10.244.0.0/16
	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config
	echo "################# CALICO INSTALLATION FOR CLUSTER NETWORK ######################"
	echo "################################################################################"
	kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/tigera-operator.yaml
	kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/custom-resources.yaml
	kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml

	Kubectl get nodes 

	echo "###############  TOKEN FOR JOIN CLUSTER #####################################"
	echo "#############################################################################"
	kubeadm token create --print-join-command > join-node.txt
	echo " Ci-dessous la commande pour joindre un nouvau worker au cluster Kubernetes"
	cat join-node.txt 

fi
