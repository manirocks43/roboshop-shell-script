LOG_FILE=/tmp/catalogue

echo "setup nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit 1
fi

echo "installing nodejs repo"
yum install nodejs -y &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit 1
fi

echo "Adding roboshop user"
useradd roboshop &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit 1
fi

echo "downloading catalogue application"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit 1
fi

cd /home/roboshop

echo "extracting catalogue application"
unzip /tmp/catalogue.zip &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit 1
fi

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "installing nodejs dependencies"
npm install &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit 1
fi

echo "setup catalogue service file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit 1
fi

systemctl daemon-reload &>>$LOG_FILE
systemctl enable catalogue &>>$LOG_FILE

echo "starting catalogue service"
systemctl restart catalogue &>>$LOG_FILE
if [ $? -eq 0 ]
then
  echo Status = SUCCESS
else
  echo Status = FAILURE
  exit 1
fi