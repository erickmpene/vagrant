#! /bin/bash

cat <<EOF | sudo tee $HOME/.bashrc
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi 


# Some more alias to avoid making mistakes:
 alias rm='rm -i'
 alias cp='cp -i'
 alias mv='mv -i'
 alias k='kubectl'
 alias kcc='kubectl config current-context'
 alias kg='kubectl get'
 alias kga='kubectl get all --all-namespaces'
 alias kgp='kubectl get pods -o wide'
 alias kgs='kubectl get services'
 alias ksgp='kubectl get pods -n kube-system'
 alias kuc='kubectl config use-context'
 alias kgc='ctr -n k8s.io containers list'
 alias kgi='kubectl get ingress -o wide'
 alias kgd='kubectl get deployment -o wide'
 alias ka='kubectl apply -f'
 alias kgn='kubectl get node -o wide'
 alias w1='kubectl describe nodes worker1'
 alias w2='kubectl describe nodes worker2'
 alias w3='kubectl describe nodes worker3'
 alias w4='kubectl describe nodes worker4'
 alias kapi='kubectl api-resources -v 6 -o wide'

 export PATH=$PATH:/usr/local/sbin
 export PATH=$PATH:/usr/local/bin
 export PATH=$PATH:/usr/sbin
 export PATH=$PATH:/sbin
 alias myip='curl ifconfig.co/'

 # enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

EOF

source ~/.bashrc
echo "Voici l'adresse ip pour se connecter en ssh : "
hostname -I