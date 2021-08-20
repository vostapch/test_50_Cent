#!/usr/bin/env bash

OSTYPE=`cat /etc/os-release | head -n 1 | sed 's/NAME="//g;s/"//g'`

if [[ "$OSTYPE" == 'Ubuntu' ]]; then
 echo "############## Installing default soft"
 sudo apt-get update -y
 sudo apt-get install python -y
# sudo apt-get dist-upgrade -y
fi
if [[ "$OSTYPE" == 'CentOS Linux' ]]; then
 sudo yum install python -y
 sudo yum update * -y
fi
