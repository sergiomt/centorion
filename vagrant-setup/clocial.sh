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
		DEPENDENCIES=( httpd java80 db62 scala212 ant194 maven353 hadoop251 zookeeper346 hbase112 openldap24 openfire393 cinnamon eclipse48 )

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

		# Create directory for Lucene files
		mkdir -m 766 -p /opt/lucene/clocialdev

    if containsApp "db62" "${DEPENDENCIES[@]}"
    then
				# Create directories for Berkeley DB files
				mkdir -m 777 -p /opt/bdb/
				mkdir -m 777 -p /opt/bdb/slogs
				mkdir -m 777 -p /opt/bdb/bucket
		fi

		if getent passwd tomcat > /dev/null 2>&1; then
    	if containsApp "db62" "${DEPENDENCIES[@]}"
    	then
				chown tomcat /opt/bdb/
				chgrp tomcat /opt/bdb/
				chown tomcat /opt/bdb/slogs
				chgrp tomcat /opt/bdb/slogs
				chown tomcat /opt/bdb/bucket
				chgrp tomcat /opt/bdb/bucket
			fi

			chown tomcat /opt/lucene/clocialdev
			chgrp tomcat /opt/lucene/clocialdev
		fi

		# Create PostgreSQL login role for it named clocial and database named clocialdev
		if containsApp "pgsql96" "${DEPENDENCIES[@]}"
		then
			echo "Creating PostgreSQL database"
			source $SETUP/clocial-db-create.sh
		else
			echo "Skipped PostgreSQL database creation"
		fi

		if containsApp "openldap24" "${DEPENDENCIES[@]}"
		then
			echo "Creating LDAP entries"
			/usr/local/bin/ldapadd -x -w secret -D "cn=Manager,dc=auth,dc=com" -f /vagrant/vagrant-setup/clocial/clocial.ldif
			/usr/local/bin/ldapadd -x -w secret -D "cn=Manager,dc=auth,dc=com" -f /vagrant/vagrant-setup/clocial/admin.ldif
		fi

		echo "Clocial successfully installed, rebooting to complete set up."

    if containsApp "cinnamon" "${DEPENDENCIES[@]}"
    then
			echo "For good performance, make sure that VirtualBox Guest additions are installed and video hardware acceleration is enabled on the virtual machine."
		fi
		
		shutdown

		cd $PPWD
	else
		echo "Clocial setup must be installed as root. Type 'sudo ./clocial.sh' for executing the script."
	fi
fi