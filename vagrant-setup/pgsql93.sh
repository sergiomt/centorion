#!/bin/bash

# From RHEL Extra Packages for Enterprise Linux (EPEL) repo
# install GDAL and JSON PostGIS 2.0 dependencies not available from yum 
if [ -d "/var/lib/pgsql" ]
	then
	echo "PostgreSQL is already installed, nothing done!"
else
	yum install -y postgresql93-server
	# Start PostgreSQL on boot
	chkconfig postgresql-9.3 on
	service postgresql-9.3 initdb
	yum install -y postgis2_93
	# Make server listen to any client address
	cd /var/lib/pgsql/9.3/data/
	# Listen to any remote client
	perl -pi -e "s/#?\s*listen_addresses\s*=\s*'localhost'(.*)/listen_addresses = '\x2A'\\1/g" postgresql.conf
	# Allow ident connection from local host
	perl -pi -e "s/host\s+all\s+all\s+127.0.0.1\x2F32\s+ident/host    all             postgres             127.0.0.1\x2F32            ident/g" pg_hba.conf
	# Allow user+password connection from any client
	echo -e "host    all             all             0.0.0.0/0               md5" >> pg_hba.conf
	chown -f postgres.postgres *.conf
	iptables -A INPUT -p tcp --dport 5432 -j ACCEPT
	service iptables save
	service iptables restart
	service postgresql-9.3 start
fi