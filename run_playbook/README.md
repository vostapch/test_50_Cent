#### How it works
First of all it was created ec2 instance with Ubuntu 18.04/bionic on it. I configured firewall rules as well ssh(22)/http(80)/https(443).
Then I give it a ping from my laptop(I downloaded and placed in .ssh/aws_keys.pem, futhermore I edited .ssh/config):
```console
vostapchuk@LM-C02FN276Q6LR:~/50_cent/test_50_Cent% ls -al ~/.ssh/aws_keys.pem
-r--------@ 1 vostapchuk  staff  1700 Aug 20 16:46 /Users/vostapchuk/.ssh/aws_keys.pem
vostapchuk@LM-C02FN276Q6LR:~/50_cent/test_50_Cent% cat ~/.ssh/config
Host *
    GSSAPIAuthentication no

Host *amazonaws.com
IdentityFile ~/.ssh/aws_keys.pem
User ubuntu
```
Ansible list-hosts/ping:
```console
vostapchuk@LM-C02FN276Q6LR:~/Documents/scripts/test_playbook% ansible --list-hosts all                                                        
[WARNING]: Found both group and host with same name: aws_ubuntu
  hosts (5):
    mysql.test.master
    mysql_test_slave
    centos.7
    ubuntu18
    aws_ubuntu
vostapchuk@LM-C02FN276Q6LR:~/Documents/scripts/test_playbook% ansible aws_ubuntu  -m ping   -u ubuntu                                 
[WARNING]: Found both group and host with same name: aws_ubuntu
aws_ubuntu | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```
Only after that we are ready to start:
```console
vostapchuk@LM-C02FN276Q6LR:~/Documents/scripts/test_playbook% ansible-playbook -i inventory/vagrant_hosts.ini playbooks/aws_test.yml -u ubuntu
[WARNING]: Found both group and host with same name: aws_ubuntu

PLAY [aws_ubuntu] ********************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************
ok: [aws_ubuntu]

TASK [nginx : 1.Debian] **************************************************************************************************************************************
ok: [aws_ubuntu] => {
    "ansible_os_family": "Debian"
}

TASK [nginx : 2.Upgrade and upgrade Debian packages] *********************************************************************************************************
changed: [aws_ubuntu]

TASK [nginx : 3.Installing default soft] *********************************************************************************************************************
ok: [aws_ubuntu] => (item=nginx)
ok: [aws_ubuntu] => (item=php-fpm)
ok: [aws_ubuntu] => (item=php-mysql)
ok: [aws_ubuntu] => (item=python3-pymysql)
ok: [aws_ubuntu] => (item=mysql-server)
ok: [aws_ubuntu] => (item=postgresql)
ok: [aws_ubuntu] => (item=postgresql-contrib)
ok: [aws_ubuntu] => (item=libpq-dev)
ok: [aws_ubuntu] => (item=python3-psycopg2)
ok: [aws_ubuntu] => (item=bash)
ok: [aws_ubuntu] => (item=openssl)
ok: [aws_ubuntu] => (item=libssl-dev)
ok: [aws_ubuntu] => (item=libssl-doc)

TASK [nginx : 4.Install config file for example2.com and restart httpd] **************************************************************************************
ok: [aws_ubuntu]

TASK [nginx : 5.Enables new site] ****************************************************************************************************************************
ok: [aws_ubuntu]

TASK [nginx : 6. Removes "default" site] *********************************************************************************************************************
ok: [aws_ubuntu]

TASK [nginx : 7. Sets Up PHP Info Page] **********************************************************************************************************************
ok: [aws_ubuntu]

TASK [nginx : Ensure the PostgreSQL service is running] ******************************************************************************************************
ok: [aws_ubuntu]

TASK [nginx : Create app database] ***************************************************************************************************************************
ok: [aws_ubuntu]

TASK [nginx : Ensure user has access to the new database] ****************************************************************************************************
changed: [aws_ubuntu]

TASK [nginx : Ensure user does not have unnecessary permissions] *********************************************************************************************
ok: [aws_ubuntu]

PLAY RECAP ***************************************************************************************************************************************************
aws_ubuntu                 : ok=12   changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

![image](https://github.com/vostapch/DevOps_online_Lviv_2020Q3Q4/blob/master/m4/task4.1/images/2.png)
