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

APP_USER=roboshop

Create_Application_User(){
  id $APP_USER &>>$LOG_FILE
    if [ $? -ne 0 ]; then
      Print "Adding Application user"
      useradd ${APP_USER} &>>$LOG_FILE
      Status_Check $?
    fi

}

APP_SETUP(){
  Print "Downloading ${COMPONENT} component content"
    cd /home/${APP_USER} &>>$LOG_FILE
    Status_Check $?
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG_FILE
    Status_Check $?

    Print "Clean up old contents"
    rm -rf /home/${APP_USER}/${COMPONENT} &>>$LOG_FILE
    Status_Check $?

    Print "Unzipping the files"
    unzip -o /tmp/${COMPONENT}.zip &>>$LOG_FILE && mv ${COMPONENT}-main ${COMPONENT} &>>$LOG_FILE
    Status_Check $?
}

Setup_SystemD_file()
{
  Print "Configure SystemD file"
    sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' \
           -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
           -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
           -e 's/CARTENDPOINT/cart.roboshop.internal/' \
           -e 's/DBHOST/mysql.roboshop.internal/' \
           /home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG_FILE
    Status_Check $?

     Print "Restart ${COMPONENT} service"
      systemctl daemon-reload &>>$LOG_FILE && systemctl restart ${COMPONENT} &>>$LOG_FILE && systemctl enable ${COMPONENT} &>>$LOG_FILE
      Status_Check $?

}

NodeJS(){
  Print "Downloading the Repos"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
  Status_Check $?

  Print "Install Node Js"
  yum install nodejs gcc-c++ -y &>>$LOG_FILE
  Status_Check $?

  Create_Application_User

  APP_SETUP


  Print "Installing Dependencies"
  cd /home/${APP_USER}/${COMPONENT} &>>$LOG_FILE && npm install &>>$LOG_FILE
  Status_Check $?

  Print "Applying permissions to Application user"
  chown -R $APP_USER:$APP_USER /home/$APP_USER
  Status_Check $?


  Setup_SystemD_file


}

Maven()
{

Print "Install Maven"
yum install maven -y &>>$LOG_FILE
Status_Check $?

Create_Application_User

APP_SETUP

Print "Maven packaging"
cd shipping &>>$LOG_FILE && mvn clean package &>>$LOG_FILE && mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
Status_Check $?

Setup_SystemD_file




}