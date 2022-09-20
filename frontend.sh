LOG_FILE=/tmp/frontend
echo Installing Nginx
yum install nginx -y &>>$LOG_FILE
echo Status = $?

echo Downloading Nginx WebContent
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
echo Status = $?

cd /usr/share/nginx/html

echo Removing old web content
rm -rf * &>>$LOG_FILE
echo Status = $?

echo Extracting WebContent
unzip /tmp/frontend.zip &>>$LOG_FILE
echo Status = $?

mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE

echo Starting Nginx service
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
echo Status = $?
