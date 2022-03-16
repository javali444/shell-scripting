#!/bin/bash

source components/common.sh

Print "Download Redis"
curl -f -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
Status_Check $?


Print "Install Redis"
yum install redis -y &>>LOG_FILE
Status_Check $?

Print "Update the configure file"
if [ -f /etc/redis.conf ]; then
  Print "Updating in /etc/redis.conf file -"
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>LOG_FILE
  Status_Check $?
fi
if [ -f /etc/redis/redis.conf ]; then
  Print "Updating in /etc/redis/redis.conf file -"
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>LOG_FILE
  Status_Check $?
fi