#!/bin/bash
# This script installs packages automatically.
printf "\n##################- APT UPDATE -##################"
sudo apt update -y

printf "\n##################- INSTALLING OPENSSH-SERVER -##################"
sudo apt install openssh-server -y
sudo sed -i -e 's/#PermitRootLogin\swithout-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo service ssh restart

printf "\n##################- INSTALLING AUTHENTICATION SSH & INPUT IP SERVER & CLIENT -##################"
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y 

printf "\n##################- -##################"
printf "\nPlease Input IP Server : ";
read ipserver;
ssh-copy-id -i ~/.ssh/id_rsa.pub root@$ipserver 

printf "\n##################- -##################"
printf "\nPlease Input IP Client : ";
read ipclient;
ssh-copy-id -i ~/.ssh/id_rsa.pub root@$ipclient 

sed -i -e "s/x.x.x.x/$ipserver/g" /opt/Report_SSH_Log/Reporter.py
sed -i -e "s/x.x.x.x/$ipserver/g" /opt/Report_SSH_Log/Client.py

printf "\n##################- INSTALLING MYSQL PYTHON -##################"
sudo apt install -y python-mysqldb mysql-server python-dev libmysqlclient-dev 
sudo apt install python-pip -y
sudo systemctl restart mysql.service
sudo sed -i -e 's/#bind-address/bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql.service

printf "\n##################- INSTALLING ANSIBLE -##################"
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

printf "\n##################- TESTING PING ANSIBLE TO SERVER AND CLIENT -##################"
sudo ansible -m ping all

printf "\n##################- INSTALLING REPORT SSH LOG USING ANSIBLE PLAYBOOK -##################"
sudo ansible-playbook /opt/Report_SSH_Log/ansible/ssh-reporting.yml 

printf "\n##################- TRYING TO SSH CLIENT TO GET REPORT -##################"
ssh root@$ipclient << EOT

exit

EOT

printf "\n##################- SHOWING REPORT -##################"
python /opt/Report_SSH_Log/Reporter.py
