#!/bin/bash

# http://www.davidghedini.com/pg/entry/install_tomcat_7_on_centos
if [ -d "/usr/share/tomcat" ]
	then

	echo "Tomcat is already installed, nothing done!"

else

	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh
	if [ -d "$JAVA_HOME" ]
		then
		if getent passwd tomcat > /dev/null 2>&1; then
			echo "tomcat user already exists"
		else
			echo "Creating user tomcat"
			groupadd tomcat
			useradd -d /usr/share/tomcat/ -K MAIL_DIR=/dev/null -g tomcat tomcat
			echo -e "tcatpassw8\ntcatpassw8\n" | passwd tomcat
		fi
		cp $SETUP/tomcat/init.d/tomcat /etc/init.d/tomcat
		chmod 755 /etc/init.d/tomcat
		# Disallow Tomcat user to login via SSH but allow SFTP 
		# http://en.wikibooks.org/wiki/OpenSSH/Cookbook/SFTP
		if grep -q -e "^Subsystem\s*sftp" /etc/ssh/sshd_config
		then
			perl -pi -e 's/Subsystem/#Subsystem/g' /etc/ssh/sshd_config
		fi
		cat ./tomcat/etc/ssh/sshd_config >> /etc/ssh/sshd_config
		systemctl restart sshd.service
		cd /usr/share
		TOMCAT_FILE="apache-tomcat-8.5.15"
		wget_and_untar http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.15/bin/ $TOMCAT_FILE.tar.gz tomcat.tar.gz
		echo "Creating additional Tomcat directories"
		if [ ! -d "/usr/share/tomcat" ]
		then
			mkdir tomcat
		fi
		cd $TOMCAT_FILE
		mv * ../tomcat
		cd ..
		rmdir $TOMCAT_FILE
		cd tomcat
		chmod 766 logs
		mkdir shared
		cd shared
		mkdir classes
		mkdir lib
		cd ../webapps
		rm -r -f examples
		cd ../bin

		tar -xzf tomcat-native.tar.gz
		rm tomcat-native.tar.gz
		cd tomcat-native-1.2.12-src/native
		echo "Compiling APR native libraries"
		# Compile APR native libraries
		OPENSSLVERSION=`openssl version`
		echo "found $OPENSSLVERSION"
		if [[ $OPENSSLVERSION == "OpenSSL 1.0.1"* ]]
			then
			# Native libraries require OpenSSL 1.0.2 but CentOS 7.3 comes with 1.0.1
			# so upgrade OpenSSL to 1.0.2 before compiling
			echo "Upgrading openssl to 1.0.2"
			source $SETUP/openssl102.sh
		fi
		./configure --with-apr=/usr/ --with-java-home=$JAVA_HOME
		# Dirty hack with openssl dynamic library to compile
		cp /opt/puppetlabs/puppet/lib/libssl.so /usr/local/ssl/lib
		make && make install
		rm /usr/local/ssl/lib/libssl.so
		cd ../../../..

		# Copy conf files
		echo "Copying .conf files"
		cp --remove-destination /vagrant/vagrant-setup/tomcat/conf/tomcat-users.xml ./conf
		cp --remove-destination /vagrant/vagrant-setup/tomcat/conf/catalina.properties ./conf
		chown -Rf tomcat.tomcat .

		# Use dcevm for dynamic class reloading on develeopment if available
		if [ -d "$SETUP/tomcat/dcevm" ]
			then
			echo "Setting DCEVM as Java hot swap runtime"
			mkdir -p $JAVA_HOME/jre/lib/amd64/dcevm
			cp $SETUP/tomcat/dcevm/*.* $JAVA_HOME/jre/lib/amd64/dcevm
			cp $SETUP/tomcat/hotswap/hotswap-agent-1.1.0.jar /usr/share/tomcat/lib
		fi

		echo "Opening port 8080"
		iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
		service iptables save
		systemctl restart iptables.service

		# Start Tomcat at boot time
		chkconfig --add tomcat
		chkconfig --level 234 tomcat on
		# Start Tomcat and check that everything was fine
		echo "Starting tomcat service"
		service tomcat start

	else
		echo "Tomcat 8.5 requires Java 8.0. Please install it with java80.sh"
	fi

fi