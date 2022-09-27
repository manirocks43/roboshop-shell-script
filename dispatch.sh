COMPONENT=dispatch
LOG_FILE=/tmp/$COMPONENT

source common.sh

echo "installing golang application"
yum install golang -y &>>$LOG_FILE
StatusCheck $?

APP_PREREQ

echo "initiate, get and build golang app server"
go mod init dispatch &>>$LOG_FILE
StatusCheck $?
go get &>>$LOG_FILE
StatusCheck $?
go build &>>$LOG_FILE
StatusCheck $?






