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
		systemctl restart httpd.service

	# 
	PHPCONF=/etc/phpPgAdmin/config.inc.php
	perl -pi -e "s/\x24conf\x5B'servers'\x5D\x5B0\x5D\x5B'host'\x5D\s*=\s*''/\x24conf\x5B'servers'\x5D\x5B0\x5D\x5B'host'\x5D = 'localhost'\\1/g" $PHPCONF
	perl -pi -e "s/\x24conf\x5B'servers'\x5D\x5B0\x5D\x5B'pg_dump_path'\x5D\s*=\s*''/\x24conf\x5B'servers'\x5D\x5B0\x5D\x5B'pg_dump_path'\x5D = '/bin/pg_dump'\\1/g" $PHPCONF
	perl -pi -e "s/\x24conf\x5B'servers'\x5D\x5B0\x5D\x5B'pg_dumpall_path'\x5D\s*=\s*''/\x24conf\x5B'servers'\x5D\x5B0\x5D\x5B'pg_dumpall_path'\x5D = '/bin/pg_dumpall'\\1/g" $PHPCONF

	fi
fi