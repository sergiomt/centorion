#!/bin/bash

if [[ $EUID -eq 0 ]]
then

	SETUP="/vagrant/vagrant-setup
	source $SETUP/include.sh

	wget_and_cp http://repo.mysql.com/ mysql-community-release-el7-5.noarch.rpm
	rpm -ivh $SETUP/cache/mysql-community-release-el7-5.noarch.rpm
	yum update

	yum install -y mysql-server
	chkconfig mysqld on
	systemctl start mysqld
	mysql_install_db
	# Harden the installation a bit by changeing MySQL root password to "vagrant"
	echo -e "\nY\nvagrant\nvagrant\nY\nY\nY\nY\n" | /usr/bin/mysql_secure_installation

else

	echo "MySQL must be installed as root. Type sudo ./mysql.sh for executing the script."

fi