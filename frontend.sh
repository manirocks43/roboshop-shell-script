echo Installing Nginx
yum install nginx -y

echo Downloading Nginx WebContent
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

cd /usr/share/nginx/html

echo Removing old web content
rm -rf *

echo Extracting WebContent
unzip /tmp/frontend.zip

mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo Starting Nginx service
systemctl enable nginx
systemctl restart nginx
