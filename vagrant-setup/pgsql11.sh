#!/bin/bash

# From RHEL Extra Packages for Enterprise Linux (EPEL) repo
# install GDAL and JSON PostGIS 2.4 dependencies not available from yum 
yum -y install geos-devel.x86_64 gdal-devel.x86_64 proj-devel.x86_64 libxml2-devel.x86_64 json-c-devel.x86_64

if [ -d "/var/lib/pgsql" ]
	then

	echo "PostgreSQL is already installed, nothing done!"

else

	# Run the following command to make PostgreSQL work if SELinux enabled on your system.
	# setsebool -P httpd_can_network_connect_db 1

	yum install -y https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm
	yum install -y postgresql11-server.x86_64

	# Start PostgreSQL on boot
	systemctl enable postgresql-11
	/usr/pgsql-11/bin/postgresql-11-setup initdb

	# Install PostGIS 2.4
	cd /etc/pki/rpm-gpg
	wget -O RPM-GPG-KEY-redhat-devel https://www.redhat.com/security/data/a5787476.txt
	rpm --import RPM-GPG-KEY-redhat-devel
	
	cd /usr/pgsql-11/

	# Dependencies required to build Postgis from source
	yum install -y postgresql11-devel.x86_64 centos-release-scl
	yum-config-manager --enable rhel-server-rhscl-7-rpms
	yum install -y devtoolset-7
	scl enable devtoolset-7 bash
	yum install -y llvm-toolset-7
	scl enable devtoolset-7 llvm-toolset-7 bash

  # Postgis fails to compile with PostgreSQL 11
  # make raises the error:
  # In file included from lwgeom_transform.c:18:0:
	# /usr/pgsql-11/include/server/utils/memutils.h:140:13: note: expected ‘MemoryContext {aka struct MemoryContextData *}’ but argument is of type ‘int’
  # extern void MemoryContextCreate(MemoryContext node,
  # lwgeom_transform.c:575:18: error: void value not ignored as it ought to be
  # PJMemoryContext = MemoryContextCreate(T_AllocSetContext, 8192,

	# wget https://download.osgeo.org/postgis/source/postgis-2.4.4.tar.gz
	# tar xvzf postgis-2.4.4.tar.gz
  # rm postgis-2.4.4.tar.gz
  # cd postgis-2.4.4
  # ./configure --with-pgconfig=/usr/pgsql-11/bin/pg_config
  # make
  # make install

  # So install Postgis from yum
  yum install -y postgis2_93

	# Make server listen to any client address
	cd /var/lib/pgsql/11/data/
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
	systemctl start postgresql-11.service
fi