#!/bin/bash

# Install all the applications required by Clocial

PPWD=$PWD

SETUP="/vagrant/vagrant-setup"
MAVEN="/usr/local/maven/bin"

containsApp () { for e in "${@:2}"; do [[ "$e" = "$1" ]] && return 0; done; return 1; }

# Check required dependencies and install if not already present

if [ -d "/usr/share/tomcat/webapps/clocial" ]
	then

	echo "Clocial is already installed, nothing done!"

else
  if [[ $EUID -eq 0 ]]
  then

		echo "Configuring Clocial set up"

		cd $SETUP
		DEPENDENCIES=( httpd pgsql96 java80 db62 scala211 ant194 maven321 hadoop251 zookeeper346 hbase112 openldap24 openfire393 tomcat85 tomcat-shared )

		cd $SETUP

		# Copy .cnf files
		cp ./clocial/etc/*.cnf /etc

		echo "Installing dependencies"

		for DEP in "${DEPENDENCIES[@]}"
		do
			source ./$DEP.sh
			cd $SETUP
		done

		echo "Creating directories"

    if containsApp "db61" "${DEPENDENCIES[@]}"
    then
			# Create directories for Berkeley DB files
			mkdir -m 777 -p /opt/bdb/
			chown tomcat /opt/bdb/
			chgrp tomcat /opt/bdb/
			mkdir -m 777 -p /opt/bdb/slogs
			chown tomcat /opt/bdb/slogs
			chgrp tomcat /opt/bdb/slogs
			mkdir -m 777 -p /opt/bdb/bucket
			chown tomcat /opt/bdb/bucket
			chgrp tomcat /opt/bdb/bucket
		fi

		# Create directory for Lucene files
		mkdir -m 766 -p /opt/lucene/clocialdev
		chown tomcat /opt/lucene/clocialdev
		chgrp tomcat /opt/lucene/clocialdev

		echo "Creating PostgreSQL database"
		
		# Create PostgreSQL login role for it named clocial and database named clocialdev
		if containsApp "pgsql93" "${DEPENDENCIES[@]}"
		then
			echo "Creating user clocial"
			adduser clocial
			# Do not set any password for Linux user clocial
			su postgres -c "psql -c \"create role clocial with password 'clocial' superuser login;\""

			echo "Creating clocialdev database"
			su postgres -c "psql -c \"create database clocialdev with owner=clocial\""
			su postgres -c "psql -c \"grant all privileges on database clocialdev to clocial\""
		
			# Create PostGIS 2.0 tables and functions in clocialdev database
      echo "Creating PostGIS spatial extensions at clocialdev database"
			su postgres -c "psql -d clocialdev -f /usr/pgsql-9.3/share/contrib/postgis-2.1/postgis.sql" > /dev/null
			su postgres -c "psql -d clocialdev -f /usr/pgsql-9.3/share/contrib/postgis-2.1/postgis_comments.sql" > /dev/null
			su postgres -c "psql -d clocialdev -f /usr/pgsql-9.3/share/contrib/postgis-2.1/spatial_ref_sys.sql" > /dev/null

			if containsApp "openfire393" "${DEPENDENCIES[@]}"
			then
				echo "Creating openfire database"
				su postgres -c "psql -c \"create database openfire with owner=clocial\""
				su postgres -c "psql -c \"grant all privileges on database openfire to clocial\""
				cat /opt/openfire/resources/database/openfire_postgresql.sql | su postgres -c "psql -d openfire"
			fi

		fi

		if containsApp "openldap24" "${DEPENDENCIES[@]}"
		then
			echo "Creating LDAP entries"
			/usr/local/bin/ldapadd -x -w secret -D "cn=Manager,dc=auth,dc=com" -f /vagrant/vagrant-setup/clocial/clocial.ldif
			/usr/local/bin/ldapadd -x -w secret -D "cn=Manager,dc=auth,dc=com" -f /vagrant/vagrant-setup/clocial/admin.ldif
		fi

			echo "Clocial successfully installed"

		cd $PPWD
	else
		echo "Clocial setup must be installed as root. Type 'sudo ./clocial.sh' for executing the script."
	fi
fi