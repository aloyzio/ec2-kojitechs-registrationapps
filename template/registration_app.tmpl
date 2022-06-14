#! /bin/bash
sudo yum update -y
sudo rpm -e --nodeps mariadb-libs-*
sudo amazon-linux-extras enable mariadb10.5
sudo yum clean metadata
sudo yum install -y mariadb
sudo mysql -V
sudo yum install -y telnet
sudo amazon-linux-extras enable java-openjdk11
sudo yum clean metadata && sudo yum -y install java-11-openjdk
mkdir /home/ec2-user/app3-usermgmt && cd /home/ec2-user/app3-usermgmt
wget https://github.com/Bkoji1150/kojitechswebapp/releases/download/v1.2.0/kojitechs-registration-app.war -P /home/ec2-user/app3-usermgmt
export DB_HOSTNAME=${endpoint}
export DB_PORT=${port}
export DB_NAME=${db_name}
export DB_USERNAME=${db_user}
export DB_PASSWORD=${db_password}
java -jar /home/ec2-user/app3-usermgmt/kojitechs-registration-app.war > /home/ec2-user/app3-usermgmt/ums-start.log &