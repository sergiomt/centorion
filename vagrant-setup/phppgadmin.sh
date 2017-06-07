#!/bin/bash

# Install phpPgAdmin

if [ -d "/usr/share/phpPgAdmin" ]
	then
	echo "phpPgAdmin is already installed, nothing done!"
else
	HTTPD=`which httpd`
	if [[ $HTTPD == "*no httpd*" ]]
		then
		echo "No httpd service found, skipping phpPgAdmin setup"
	else
		yum install -y phpPgAdmin
		cp -f /vagrant/vagrant-setup/pgsql/phpPgAdmin.conf /etc/httpd/conf.d/
		service httpd restart
	fi
fi