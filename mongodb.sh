LOG_FILE=/tmp/mongodb

echo "Setting up mongodb service"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
echo Status = $?

echo "installing mongodb service"
yum install -y mongodb-org &>>$LOG_FILE
echo Status = $?

systemctl enable mongod
systemctl start mongodx``






