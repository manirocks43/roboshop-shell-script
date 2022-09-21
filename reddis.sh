LOG_FILE=/tmp/redis

source common.sh

echo "Setup YUM Repos for Redis"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/redis
StatusCheck $?

echo "enabling Redis YUM module"
dnf module enable redis:remi-6.2 -y &>>/tmp/redis
StatusCheck $?

echo "Installing Redis"
yum install redis -y &>>/tmp/redis
StatusCheck $?

echo"Updating Redis listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's/127.0.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
StatusCheck $?

systemctl enable redis &>>/tmp/redis

echo "Start redis"
systemctl restart redis &>>/tmp/redis
StatusCheck $?