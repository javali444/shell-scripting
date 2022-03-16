#!/bin/bash

echo "Installing Nginx"
yum install nginx -y

echo "Downloading Nginx"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"


echo "Old files clean up"
cd /usr/share/nginx/html
rm -rf *

echo "Unzipping content"
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md

echo "Configuration set up"
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo "Starting Nginx"
systemctl enable nginx
systemctl start nginx