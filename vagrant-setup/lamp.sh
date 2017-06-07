#!/bin/bash

# MySQL
yum install -y mysql-server
chkconfig mysqld on
service mysqld start
mysql_install_db
# Harden the installation a bit by changeing MySQL root password to "vagrant"
echo -e "\nY\nvagrant\nvagrant\nY\nY\nY\nY\n" | /usr/bin/mysql_secure_installation

# PHP
yum install -y php-mysql.x86_64

#phpMyAdmin
# wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# rpm -ivh epel-release*
# rm epel-release-6-8.noarch.rpm
yum install -y phpmyadmin
