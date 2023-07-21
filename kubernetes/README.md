
Here are scripts that will easily and automatically deploy a kubernetes cluster without a worker.
You can customize the files as you see fit.


Vagrantfile => allows to deploy a virtual machine with the bento/Ubuntu 20.04 linux operating system
add-on.sh => script in bash for adding a user other than vagrant when deploying the virtual machine in VirtualBox
setup-kubernetes.sh => script for installing a kubernetes cluster with kubeadm and Calico tools for the CNI.
add-alias.sh => add kubectl aliases

/!\ FOR THE INSTALLATION OF KUBERNETES, A UBUNTU BOX IS IMPERATIVELY REQUIRED. If you are using Debian, remove the "if" condition in the setup-kubernetes file
