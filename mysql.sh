LOG_FILE=/tmp/mysql

source common.sh

echo "Setup mysql Repo file"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
StatusCheck $?

echo "Disable Mysql default module to enable 5.7 Mysql"
dnf module disable mysql -y &>>$LOG_FILE
StatusCheck $?

echo "Install Mysql"
yum install mysql-community-server -y &>>$LOG_FILE
StatusCheck $?

echo "start mysql service"
systemctl enable mysqld &>>$LOG_FILE
systemctl restart mysqld &>>$LOG_FILE
StatusCheck $?

DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$ROBOSHOP_MYSQL_PASSWORD');
FLUSH PRIVILEGES;" >/tmp/root-pass.sql

mysql -uroot -pRoboShop@1

uninstall plugin validate_password;

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"

cd /tmp
unzip mysql.zip
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql
