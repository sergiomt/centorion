#!/bin/bash

if [[ $EUID -eq 0 ]]
then
	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh

	# Apache HTTP Server
	source httpd.sh

	# MySQL
	source mysql51.sh

	# PHP
	yum install -y php-mysql.x86_64

	# phpMyAdmin
	HTTPD=`which httpd`
	if [[ $HTTPD == "*no httpd*" ]]
		then
		echo "No httpd service found, skipping phpMyAdmin setup"
	else
		yum install -y phpmyadmin
	fi

else

	echo "LAMP stack must be installed as root. Type sudo ./lamp.sh for executing the script."

fi