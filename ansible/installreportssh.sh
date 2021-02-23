#!/bin/bash
# This script installs packages automatically.
printf "\n##################Update##################\n"
sudo apt update -y

printf "\n##################INSTALLING OPENSSH-SERVER##################\n"
sudo apt install openssh-server -y
sudo sed -i -e 's/#PermitRootLogin\swithout-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo service ssh restart
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y 

printf "\nPlease Input IP Server : ";
read ipserver;
ssh-copy-id -i ~/.ssh/id_rsa.pub root@$ipserver 

printf "\nPlease Input IP Client : ";
read ipclient;
ssh-copy-id -i ~/.ssh/id_rsa.pub root@$ipclient 

sed -i -e "s/x.x.x.x/$ipserver/g" /opt/Report_SSH_Log/Reporter.py
sed -i -e "s/x.x.x.x/$ipserver/g" /opt/Report_SSH_Log/Client.py

printf "\nSTART INSTALLING MYSQL…."
sudo apt install -y python-mysqldb mysql-server python-dev libmysqlclient-dev 
sudo apt install python-pip -y
sudo systemctl restart mysql.service
sudo sed -i -e 's/#bind-address/bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql.service

printf "\nSTART INSTALLING ANSIBLE…."
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible -y
sudo ansible --version
cat <<EOF > /etc/ansible/hosts
[server]
$ipserver
[client]
$ipclient
EOF
sudo ansible -m ping all #testing until showing pong

sudo ansible-playbook /opt/Report_SSH_Log/ansible/ssh-reporting.yml 

ssh root@$ipclient << EOT

exit

EOT

python /opt/Report_SSH_Log/Reporter.py

