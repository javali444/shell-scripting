#!/bin/bash

user_id=$(id -u)
if [ "$user_id" -ne 0 ]
then
  echo "You should be a root user to run the script"
  exit 1
fi


echo "Installing Nginx"
yum install nginx -y

echo "Downloading Nginx"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"


echo "Old files clean up"
rm -rf /usr/share/nginx/html/*

echo "Unzipping content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md

echo "Configuration set up"
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo "Starting Nginx"
systemctl restart nginx
systemctl enable nginx
