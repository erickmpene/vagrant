#! /bin/bash

user="my_user"
password="my_password"
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
echo "Public key for $user :" 
cat /home/"$user"/.ssh/id_rsa.pub
echo "The user $user has been successfully created with the password $password and an RSA key pair."
usermod -aG sudo "$user"
echo $HOSTNAME
hostname -I

