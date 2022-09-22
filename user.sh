LOG_FILE=/tmp/user

source common.sh

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

echo "downloading user application"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /home/roboshop

echo "Cleaning old content"
rm -rf user &>>$LOG_FILE
StatusCheck $?

echo "extracting user application"
unzip /tmp/user.zip &>>$LOG_FILE
StatusCheck $?

mv user-main user
cd /home/roboshop/user

echo "installing nodejs dependencies"
npm install &>>$LOG_FILE
StatusCheck $?

echo "update systemd service file"
sed -i -e ' s/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service
StatusCheck $?

echo "setup user service file"
mv /home/roboshop/user/systemd.service /etc/systemd/system/cuser.service &>>$LOG_FILE
StatusCheck $?

systemctl daemon-reload &>>$LOG_FILE
systemctl enable user &>>$LOG_FILE

echo "starting user service"
systemctl restart user &>>$LOG_FILE
StatusCheck $?