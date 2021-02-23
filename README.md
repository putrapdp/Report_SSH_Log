# Report_SSH_Log

## Table of contents
- [Requirement](#requirement)
- [First Setup](#first-setup)
- [Adding Another Client](#adding-another-client)
- [Troubleshooting](#troubleshooting)

## Requirement 
- Please make sure, know password for root _(in this guidance using root as default)_
- If dont know password for reset, kindly can reset using :
   ```bash
   sudo passwd root
   ```
-  Please ensure between Server and Clients are reachable. 
-  Tested with Ubuntu 18.04

## First Setup
- If the first time to setup, please using this guidance :
```python
sudo apt update -y
sudo apt install git -y
cd /opt
sudo git clone https://github.com/putrapdp/Report_SSH_Log.git
cd /opt/Report_SSH_Log
sudo git checkout .
sudo chmod 755 /opt/Report_SSH_Log #for_learning_purpose
```
- After installed
```python
bash first_install.sh
```
- Will prompt for input IP Server :
    ```python
    Please Input IP Server :
    ```
  You need to entering an IP Server, example (192.168.0.110 as your IP Server) : 
    ```python
    Please Input IP Server : 192.168.0.110
    ```
- When asking type "yes", example :
    ```python
    Are you sure you want to continue connecting (yes/no)? yes
    ```
- Then entering password for root (in this guide using root as default)
    ```python
    root@192.168.0.110's password:
    ```
- Will prompt for input IP Client, example (192.168.0.112 as your IP Client) :
    ```python
    Please Input IP Client :
    ```
  You need to entering an IP Client, example : 
    ```python
    Please Input IP Server : 192.168.0.112
    ```
- When asking type "yes", example :
    ```python
    Are you sure you want to continue connecting (yes/no)? yes
    ```
- Then entering password for root (in this guide using root as default)
    ```python
    root@192.168.0.112's password:
    ```
- If there's no error, last prompt will showing 
    ```python
     --------------------------------
    | Metrics for ssh log-in attempts|
    |--------------------------------|
    | * 192.168.0.112 had 1 attempt
     --------------------------------
     ```

## Adding Another Client

- If adding several New Clients, can using 

  REPLACE z.z.z.z with IP NEW CLIENT
  
    ```bash
    ssh-copy-id -i ~/.ssh/id_rsa.pub root@z.z.z.z
    sed -i -e "\$az.z.z.z" /etc/ansible/hosts
    ansible-playbook /opt/Report_SSH_Log/ansible/newclient_batch.yml
    ```
- If adding a lot of New Client, need to edit /etc/ansible/hosts under [client], example : 
    ```bash
    [server]
    192.168.0.110
    [client]
    192.168.0.112
    **new.ip.address.here**
    ```
  After that run :
    ```bash
    ansible-playbook /opt/Report_SSH_Log/ansible/newclient_batch.yml
    ```
## Troubleshooting
-  Enter command to get report
    ```bash
    python /opt/Report_SSH_Log/Reporter.py
    ```
