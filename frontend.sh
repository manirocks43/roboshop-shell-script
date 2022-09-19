echo Installing Nginx
yum install nginx -y &>>/tmp/frontend
echo Status = $?

echo Downloading Nginx WebContent
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend
echo Status = $?

cd /usr/share/nginx/html

echo Removing old web content
rm -rf * &>>/tmp/frontend
echo Status = $?

echo Extracting WebContent
unzip /tmp/frontend.zip &>>/tmp/frontend
echo Status = $?

mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo Starting Nginx service
systemctl enable nginx &>>/tmp/frontend
systemctl restart nginx &>>/tmp/frontend
echo Status = $?
