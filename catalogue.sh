LOG_FILE=/tmp/catalogue
ID=$(id -u)

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

echo "downloading catalogue application"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /home/roboshop

echo "Cleaning old content"
rm -rf catalogue &>>$LOG_FILE
StatusCheck $?

echo "extracting catalogue application"
unzip /tmp/catalogue.zip &>>$LOG_FILE
StatusCheck $?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "installing nodejs dependencies"
npm install &>>$LOG_FILE
StatusCheck $?

echo "setup catalogue service file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
StatusCheck $?

systemctl daemon-reload &>>$LOG_FILE
systemctl enable catalogue &>>$LOG_FILE

echo "starting catalogue service"
systemctl restart catalogue &>>$LOG_FILE
StatusCheck $?