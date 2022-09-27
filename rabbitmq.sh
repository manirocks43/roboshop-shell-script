COMPONENT=rabbitmq
source common.sh
LOG_FILE=/tmp/$COMPONENT

echo "Setup RabbitMQ repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
StatusCheck $?

echo "Installing Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>$LOG_FILE
StatusCheck $?

echo "Installing RabbitMQ"
yum install rabbitmq-server -y --nobest &>>$LOG_FILE
StatusCheck $?

echo "Starting RabbitMQ server"
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl restart rabbitmq-server &>>$LOG_FILE
StatusCheck $?

sudo rabbitmqctl list_users | grep roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
  echo "Adding application user in RabbitMQ"
  rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
  StatusCheck $?
fi
echo "Setting application user tags in RabbitMQ"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
StatusCheck $?

echo "Adding permissions for app user in RabbitMQ"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
StatusCheck $?