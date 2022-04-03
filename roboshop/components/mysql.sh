#!/bin/bash

source components/common.sh

Print "Setup MySQL repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
Status_Check $?


Print "Install MySQL"
yum install mysql-community-server -y &>>$LOG_FILE
Status_Check $?

Print "Enable and restart MySQL"
systemctl enable mysqld &>>$LOG_FILE && systemctl start mysqld &>>$LOG_FILE
Status_Check $?


echo 'show databases' | mysql -uroot -pRoboShop@1 &>>${LOG_FILE}
if [ 0 -ne $? ]; then
  Print "Change Default Root Password"
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql
  DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
  mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql &>>${LOG_FILE}
  StatCheck $?
fi
