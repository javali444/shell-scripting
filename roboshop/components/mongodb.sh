#!/bin/bash


source components/common.sh

Print "Setting up Mongodb repos"
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
Status_Check $?

Print "Install Mongodb"
yum install -y mongodb-org &>>$LOG_FILE
Status_Check $?


Print "Updating Mongodb configuration file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
Status_Check $?


Print "Starting Mongodb"
systemctl enable mongod &>>LOG_FILE && systemctl restart mongod &>>$LOG_FILE
Status_Check $?


Print "Downloading Schema"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
Status_Check $?


Print "Extracting Schema"
cd /tmp &>>$LOG_FILE && unzip -o mongodb.zip &>>$LOG_FILE
Status_Check $?


Print "Load Schema"
cd mongodb-main &>>$LOG_FILE
for schema_value in catalogue users; do
  Print "Loading ${schema_value}"
  mongo < ${schema_value}.js &>>$LOG_FILE
  Status_Check $?
done



