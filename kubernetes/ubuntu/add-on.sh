#! /bin/bash

user="myuser"
password="Pa$$w0rd"
apt-get update
apt-get install -y sudo
apt-get install -y htop vim git net-tools dnsutils tcptraceroute ccze tree
useradd -m -s /bin/bash "$user"
echo "$user:$password" | chpasswd 
mkdir -p /home/"$user"/.ssh
touch /home/"$user"/.ssh/authorized_keys
chown -R "$user":"$user" /home/"$user"/.ssh
chmod 700 /home/"$user"/.ssh
chmod 600 /home/"$user"/.ssh/authorized_keys
ssh-keygen -t rsa -b 4096 -C "clé pour $user" -N "" -f /home/"$user"/.ssh/id_rsa
echo "Clé publique pour $user :" 
cat /home/"$user"/.ssh/id_rsa.pub
echo "Utilisateur $user créé avec succès avec le mot de passe $password et une paire de clés RSA."
usermod -aG sudo "$user"
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEe2Ox3VxwJUCaIOhTpU0y6Yvlq6cTH6msiZluedh3Xl jenkins" > /home/"$user"/.ssh/authorized_keys
echo $HOSTNAME
hostname -I
