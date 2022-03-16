#!/bin/bash


source components/common.sh

Print "Setting up Mongodb repos"
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE
Status_Check $?

Print "Install Mongodb"
yum install -y mongodb-org &>>LOG_FILE
Status_Check $?


Print "Updating Mongodb configuration file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
Status_Check $?


Print "Starting Mongodb"
systemctl enable mongod &>>LOG_FILE && systemctl restart mongod &>>LOG_FILE
Status_Check $?



# curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js

