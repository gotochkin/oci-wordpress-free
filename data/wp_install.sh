#!/bin/bash
# Created by: Gleb Otochkin - gleb.otochkin@gmail.com 
# Version 1.00 11-Jun-2021
#
# Description: Script to install wordpress to the host
# 
########################################################################
#
# Install the necessary packages
. ~/.bash_profile

sudo yum install -y rh-php73-php >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log 
sudo cp /opt/rh/rh-php73/enable /etc/profile.d/php7.3.sh >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo systemctl start  httpd24-httpd.service >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log 
sudo systemctl enable  httpd24-httpd.service >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo mkdir /var/www/ >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo ln -s /opt/rh/httpd24/root/var/www/html /var/www/html >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo yum install -y rh-php73-php-mysqlnd rh-php73-php-gd rh-php73-php-mbstring rh-php73-php-xml rh-php73-php-json >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo yum install -y mysql-server >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo systemctl start mysqld >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
mysqlpwd=`sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $13}'`
sudo firewall-offline-cmd  --zone=public --add-port 80/tcp
sudo firewall-offline-cmd  --zone=public --add-port 443/tcp
sudo systemctl restart firewalld >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log

echo "<?php phpinfo(); ?>" | sudo tee -a /var/www/html/info.php

mysql -u root -p${mysqlpwd} --connect-expired-password<<EOF>>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysqlpwd}';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

#TO DO: prepare acceptable random password for wordpress user in MySQL
#wppwd=`< /dev/urandom tr -cd "[:print:]" | head -c 16; echo`
#echo $wppwd > ~/.wppwd
echo $mysqlpwd > ~/.wppwd

mysql -u root -p${mysqlpwd}<<EOF>>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
CREATE USER 'wordpress'@'localhost' IDENTIFIED WITH mysql_native_password BY '${wppwd}';
CREATE DATABASE wpdb;
GRANT ALL PRIVILEGES ON wpdb.* to 'wordpress'@'localhost';
FLUSH PRIVILEGES;
EOF

#
# Download the latest Wordpress
#
TRY=3; until [ $TRY -eq 0 ] || curl https://wordpress.org/latest.tar.gz -o latest.tar.gz ; do echo $TRY; echo "downloaded?" ; TRY=$(expr $TRY - 1); sleep 15; done;
#
# Unpack the wordpress
#
sudo tar zxf latest.tar.gz -C /var/www/html/ --strip 1 >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo mkdir /var/www/html/wp-content/uploads >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo chown apache. -R /opt/rh/httpd24/root/var/www/html >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo chcon -t httpd_sys_rw_content_t /opt/rh/httpd24/root/var/www/html -R >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo chown apache:apache /var/www/html/wp-content/uploads >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log
sudo systemctl restart  httpd24-httpd.service >>/home/opc/wp_install.log 2>>/home/opc/wp_install.log

echo "Password for the worpress user is in the file ~/.wppwd"