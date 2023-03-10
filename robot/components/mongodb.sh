#!/bin/bash 

# set -e 

COMPONENT=mongo
LOGFILE="/tmp/$COMPONENT.log"

# Validting whether the executed user is a root user or not 
ID=$(id -u)

if [ "$ID" -ne 0 ] ; then 
    echo -e "\e[31m You should execute this script as a root user or with a sudo as prefix \e[0m" 
    exit 1
fi 

stat() {
    if [ $1 -eq 0 ] ; then 
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
        exit 2
    fi 
}

echo -n "Configuring the $COMPONENT repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $? 

echo -n "Installing $COMPONENT"
yum install -y mongodb-org  &>> $LOGFILE
stat $? 






# ## nstall MongoDB Manual Steps.

# Ref URL: [https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/)

# 1. Setup MongoDB repos.

# ```bash
# # curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
# ```

# 1. Install Mongo & Start Service.

# ```bash
# # yum install -y mongodb-org
# # systemctl enable mongod
# # systemctl start mongod

# ```

# 1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in the config file, so that MongoDB can be accessed by other services.

# Config file:   `# vim /etc/mongod.conf`

# ![mongodb-update.JPG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/87c01042-0f64-4ac4-ae5a-ffaf62836290/mongodb-update.jpg)

# - Then restart the service

# ```bash
# # systemctl restart mongod
# ```

  

# - Every Database needs the schema to be loaded for the application to work.

# ---

#       `Download the schema and inject it.`

# ```
# # curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"

# # cd /tmp
# # unzip mongodb.zip
# # cd mongodb-main
# # mongo < catalogue.js
# # mongo < users.js
# ```

# Symbol `<` will take the input from a file and give that input to the command.

# - Now proceed with the next component `CATALOGUE`

echo -n "Installing Ngnix : "
yum install nginx -y &>> $LOGFILE
stat $? 

echo -n "Downloading the $COMPONENT component :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $? 

echo -n "Performing Cleanup of Old $COMPONENT Content :"
cd /usr/share/nginx/html
rm -rf *  &>> $LOGFILE
stat $? 

echo -n "Copying the downloaded $COMPONENT content: "
unzip /tmp/$COMPONENT.zip  &>> $LOGFILE
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

stat $? 

echo -n "Starting the service: "
systemctl enable nginx  &>> $LOGFILE
systemctl restart nginx &>> $LOGFILE
stat $? 