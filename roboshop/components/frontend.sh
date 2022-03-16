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


echo "Installing Nginx"
yum install nginx -y
Status_Check $?



echo "Downloading Nginx"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
Status_Check $?


echo "Old files clean up"
rm -rf /usr/share/nginx/html/*
Status_Check $?


echo "Unzipping content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
Status_Check $?


echo "Configuration set up"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
Status_Check $?


echo "Starting Nginx"
systemctl restart nginx
Status_Check $?


systemctl enable nginx
Status_Check $?