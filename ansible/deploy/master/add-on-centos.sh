
#!/bin/bash
yum -y update
yum -y install epel-release
yum install -y python3 git nano curl wget net-tools zsh 
sudo useradd -m -s /bin/zsh MyUser 
sudo usermod -aG wheel MyUser
sudo -u MyUser ssh-keygen -t rsa -N '' -f /home/MyUser/.ssh/id_rsa <<< y
echo "PUT YOUR PUBLIC KEY HERE !!!" > /home/MyUser/.ssh/authorized_keys
sudo chmod 600 /home/MyUser/.ssh/authorized_keys
sudo chown -R MyUser:MyUser /home/MyUser/.ssh
cat >> /etc/sudoers.d/MyUser-sudoers << EOF
MyUser        ALL=(ALL)       NOPASSWD: ALL
EOF

if [ $1 == "ansible-master" ]
then
  # install ansible
  curl -sS https://bootstrap.pypa.io/pip/3.6/get-pip.py | sudo python3
  /usr/local/bin/pip3 install ansible
  yum install -y sshpass
  
  # Install zsh if needed
  export ENABLE_ZSH="true"
if [[ !(-z "$ENABLE_ZSH")  &&  ($ENABLE_ZSH == "true") ]]
    then
      echo "We are going to install zsh"
      sudo yum -y install zsh git
      echo "vagrant" | chsh -s /bin/zsh vagrant
      su - vagrant  -c  'echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
      su - vagrant  -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
      sed -i 's/^plugins=/#&/' /home/vagrant/.zshrc
      echo "plugins=(git  colored-man-pages aliases copyfile  copypath zsh-syntax-highlighting jsontools)" >> /home/vagrant/.zshrc
      sed -i "s/^ZSH_THEME=.*/ZSH_THEME='agnoster'/g"  /home/vagrant/.zshrc
    else
      echo "The zsh is not installed on this server"
  fi
fi
echo "For this Stack, you will use $(ip -f inet addr show enp0s8 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') IP Address"


