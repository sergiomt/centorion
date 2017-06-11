#!/bin/bash

SETUP="/vagrant/vagrant-setup"
if [ -d "/usr/share/tomcat" ]
then
else
	echo "Cannot find Tomcat home at /usr/share/tomcat"
	if [ -d "/vagrant/clocial/clocial-web/target/clocial-web-1.0" ]
		then
	echo "Cannot find Clocial webapp target at /vagrant/clocial/clocial-web/target/"
		else

			# METHOD 1
			# Create context for clocial webapp
			# and copy webapp configuration files
			mkdir -p /usr/share/tomcat/conf/Catalina/localhost
			cp $SETUP/clocial/conf/Catalina/localhost/clocial.xml /usr/share/tomcat/conf/Catalina/localhost
			cp -r -f $SETUP/clocial/webapps/conf/WEB-INF/* /vagrant/clocial/clocial-web/target/clocial-web-1.0/WEB-INF

			# METHOD 2
			# Create a symbolic link from Tomcat webapps to Maven target
			# This is an alternative to creating a context with docBase=/vagrant/clocial/clocial-web/target/clocial-web-1.0
			# if [ ! -h "/user/share/tomcat/webapps/clocial" ]
			# then
			#		ln -s /vagrant/clocial/clocial-web/target/clocial-web-1.0 /usr/share/tomcat/webapps/clocial
			#		cp -r -f $SETUP/clocial/webapps/conf/WEB-INF/* /usr/share/tomcat/webapps/clocial/WEB-INF
			# fi

		fi
	fi
fi