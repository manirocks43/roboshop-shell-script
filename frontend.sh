LOG_FILE=/tmp/frontend

source common.sh

echo "Installing Nginx"
yum install nginx -y
StatusCheck $?

echo "Downloading Nginx WebContent"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /usr/share/nginx/html

echo "Removing old web content"
rm -rf * &>>$LOG_FILE
StatusCheck $?

echo "Extracting WebContent"
unzip /tmp/frontend.zip &>>$LOG_FILE
StatusCheck $?

mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo "Starting Nginx service"
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
StatusCheck $?
