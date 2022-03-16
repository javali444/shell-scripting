#!/bin/bash

source components/common.sh

Print "Installing Nginx"
yum install nginx -y &>>$LOG_FILE
Status_Check $?



Print "Downloading Nginx"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
Status_Check $?


Print "Old files clean up"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
Status_Check $?
cd /usr/share/nginx/html

Print "Unzipping content"
unzip /tmp/frontend.zip &>>$LOG_FILE && mv frontend-main/* . &>>$LOG_FILE && mv static/* . &>>$LOG_FILE && rm -rf frontend-main README.md &>>$LOG_FILE
Status_Check $?


Print "Configuration set up"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
Status_Check $?


Print "Starting Nginx"
systemctl restart nginx &>>$LOG_FILE && systemctl enable nginx &>>$LOG_FILE
Status_Check $?
