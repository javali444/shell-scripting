#!/bin/bash

# checking if the user is a root user or not
user_id=$(id -u)
if [ "$user_id" -ne 0 ]
then
  echo "You should be a root user to run the script"
  exit 1
fi

#function to check if the command execution status is SUCCESS/FAILURE
Status_Check(){
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

#function to print the message comment
Print()
{
  echo -e "\n---------------$1---------------\n" &>>$LOG_FILE
  echo -e "\e[35m$1\e[0m"
}

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

Print "Setting up Mongodb repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE
Status_Check &?

Print "Install Mongodb"
yum install -y mongodb-org
Status_Check &?


Print "Starting Mongodb"
systemctl enable mongod &>>LOG_FILE && systemctl start mongod &>>LOG_FILE
Status_Check &?


# curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js

