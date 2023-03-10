#!/bin/bash 

set -e 

# Validting whether the executed user is a root user or not 
USER_ID=$(id -u)

if [ "USER_ID" -ne 0 ] ; then 
    echo -e "\e[32m You should execute this script as a root user or with a sudo as prefix \e[0m" 
    exit 1
fi 

yum install nginx -y 

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl restart nginx



# # Here are my 3 observations :
# 1) Few of the steps are failed, still my script executed irrespective of the failure.  : set -e 
# 2) Installation failed because I've not validated that I've root privileges 
# 3) The information I would like to provide is like Sucess or Failure