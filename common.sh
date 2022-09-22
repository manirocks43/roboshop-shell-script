if [ $ID -ne 0 ]
  then
  echo You should run this script as a root user or with sudo privilages
  exit 1
fi

StatusCheck () {
  if [ $1 -eq 0 ]
    then
    echo -e Status = "\e[32mSUCCESS\e[0m"
    else
    echo -e Status = "\e[31mFAILURE\e[0m"
    exit 1
  fi
}

NODEJS() {
  echo "setup nodejs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
  StatusCheck $?

  echo "installing nodejs repo"
  yum install nodejs -y &>>$LOG_FILE
  StatusCheck $?

  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ] ; then
    echo "Adding roboshop user"
    useradd roboshop &>>$LOG_FILE
    StatusCheck $?
  fi

  echo "downloading $COMPONENT application"
  curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/$COMPONENT/archive/main.zip" &>>$LOG_FILE
  StatusCheck $?

  cd /home/roboshop

  echo "Cleaning old content"
  rm -rf $COMPONENT &>>$LOG_FILE
  StatusCheck $?

  echo "extracting $COMPONENT application"
  unzip /tmp/$COMPONENT.zip &>>$LOG_FILE
  StatusCheck $?

  mv $COMPONENT-main $COMPONENT
  cd /home/roboshop/$COMPONENT

  echo "installing nodejs dependencies"
  npm install &>>$LOG_FILE
  StatusCheck $?

  echo "update systemd service file"
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/$COMPONENT/systemd.service
  StatusCheck $?

  echo "setup $COMPONENT service file"
  mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>>$LOG_FILE
  StatusCheck $?

  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable $COMPONENT &>>$LOG_FILE

  echo "starting $COMPONENT service"
  systemctl start $COMPONENT &>>$LOG_FILE
  StatusCheck $?
}