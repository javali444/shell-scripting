#!/bin/bash

source components/common.sh

Print "Download Redis"
curl -f -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
Status_Check $?


Print "Install Redis"
yum install redis -y &>>LOG_FILE
Status_Check $?