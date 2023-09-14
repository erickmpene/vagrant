
#!/bin/bash

MyUSer=didier
yum -y update
yum -y install epel-release
yum install -y python3 git nano curl wget net-tools zsh 
sudo useradd -m -s /bin/zsh $MyUSer  
sudo usermod -aG wheel $MyUser
sudo -u $MyUser ssh-keygen -t rsa -N '' -f /home/$MyUser/.ssh/id_rsa <<< y
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEe2Ox3VxwJUCaIOhTpU0y6Yvlq6cTH6msiZluedh3Xl jenkins" > /home/$MyUser/.ssh/authorized_keys
sudo chmod 600 /home/$MyUser/.ssh/authorized_keys
sudo chown -R $MyUser:$MyUser /home/$MyUser/.ssh
cat >> /etc/sudoers.d/$MyUser << EOF
$MyUser        ALL=(ALL)       NOPASSWD: ALL
EOF

echo "We are going to install zsh"
echo $MyUser | chsh -s /bin/zsh $MyUser
su - $MyUser -c  'echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
su - $MyUser -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
sed -i 's/^plugins=/#&/' /home/$MyUser/.zshrc
echo "plugins=(git  colored-man-pages aliases copyfile  copypath zsh-syntax-highlighting jsontools)" >> /home/$MyUser/.zshrc
sed -i "s/^ZSH_THEME=.*/ZSH_THEME='agnoster'/g"  /home/$MyUser/.zshrc
echo "For this Stack, you will use $(ip -f inet addr show enp0s8 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') IP Address"


