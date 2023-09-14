#!/bin/bash
MyUser=didier
sudo apt update
sudo apt upgrade -y 
sudo apt install -y python3 python3-pip git nano curl wget net-tools zsh 
sudo useradd -m -s /bin/zsh MyUser 
sudo usermod -aG sudo MyUser
sudo -u MyUser ssh-keygen -t rsa -N '' -f /home/MyUser/.ssh/id_rsa <<< y
su - MyUser -c  'echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
su - MyUser -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
sed -i 's/^plugins=/#&/' /home/MyUser/.zshrc
echo "plugins=(git  colored-man-pages aliases copyfile  copypath zsh-syntax-highlighting jsontools)" >> /home/MyUser/.zshrc
sed -i "s/^ZSH_THEME=.*/ZSH_THEME='agnoster'/g"  /home/MyUser/.zshrc
sudo su 
echo "PUT YOUR PUBLIC KEY HERE !!!" > /home/MyUser/.ssh/authorized_keys
chmod 600 /home/MyUser/.ssh/authorized_keys
chown -R MyUser:MyUser /home/MyUser/.ssh

cat >> /etc/sudoers.d/MyUser << EOF
MyUser        ALL=(ALL)       NOPASSWD: ALL
EOF
exit

