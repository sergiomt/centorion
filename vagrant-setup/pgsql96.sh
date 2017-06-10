#!/bin/bash

# From RHEL Extra Packages for Enterprise Linux (EPEL) repo
# install GDAL and JSON PostGIS 2.0 dependencies not available from yum 

if [ -d "/var/lib/pgsql" ]
	then

	echo "PostgreSQL is already installed, nothing done!"

else

	Run the following command to make PostgreSQL work if SELinux enabled on your system.
	# setsebool -P httpd_can_network_connect_db 1

	yum install -y https://yum.postgresql.org/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
	yum install -y postgresql96-server

	# Start PostgreSQL on boot
	chkconfig postgresql-9.6 on
	/usr/pgsql-9.6/bin/postgresql96-setup initdb

	# Install PostGIS 2.0
	yum install -y postgis2_96

	# Make server listen to any client address
	cd /var/lib/pgsql/9.6/data/
	# Listen to any remote client
	perl -pi -e "s/#?\s*listen_addresses\s*=\s*'localhost'(.*)/listen_addresses = '\x2A'\\1/g" postgresql.conf
	# Allow ident connection from localhost
	perl -pi -e "s/host\s+all\s+all\s+127.0.0.1\x2F32\s+ident/host    all             postgres             127.0.0.1\x2F32            ident/g" pg_hba.conf
	# Allow user+password connection from any client
	echo -e "host    all             all             0.0.0.0/0               md5" >> pg_hba.conf
	chown -f postgres.postgres *.conf

	iptables -A INPUT -p tcp --dport 5432 -j ACCEPT
	service iptables save
	systemctl restart iptables
	systemctl start postgresql-9.6.service
fi