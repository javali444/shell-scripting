#!/bin/bash

source components/common.sh

Print "Downloading the Repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
Status_Check $?

Print "Install Node Js"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
Status_Check $?

id $APP_USER &>>$LOG_FILE
if [ $? -ne 0 ]; then
  Print "Adding Application user"
  useradd ${APP_USER} &>>$LOG_FILE
fi
Status_Check $?

Print "Downloading Catalogue content"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
Status_Check $?

Print "Clean up old contents"
rm -rf /home/{APP_USER}/catalogue &>>$LOG_FILE
Status_Check $?

Print "Unzipping the files"
cd /home/{APP_USER} &>>$LOG_FILE && unzip -o /tmp/catalogue.zip &>>$LOG_FILE && mv catalogue-main catalogue &>>$LOG_FILE
Status_Check $?


Print "Installing Dependencies"
cd /home/{APP_USER}/catalogue &>>$LOG_FILE && npm install &>>$LOG_FILE
Status_Check $?
