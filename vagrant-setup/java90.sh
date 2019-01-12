#!/bin/bash

JAVA=/usr/java
JDK=$JAVA/jdk-9.0.4

# Install Java 8
if [ -d "$JDK" ]
	then

	echo "Java 9.0 is already installed, nothing done!"

else

	source /vagrant/vagrant-setup/include.sh

	# Install Java 9

	RPM=c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.rpm
	OTN=otn/java/jdk/9.0.4+11

	if [ ! -f "$SETUP/cache/$RPM" ]
		then
		echo "Downloading JDK 9.0"
		wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/$OTN/$RPM" -P $SETUP/cache
	fi
	rpm -Uvh $SETUP/cache/$RPM

	cd /etc/alternatives
	if [ -L "jre" ]
	then
		unlink jre > /dev/null 2>&1
	fi
	if [ -L "jre" ]
	then
		unlink jre_exports > /dev/null 2>&1
	fi
	# ln -s $JDK/jre jre

	if [ -L "latest" ]
	then
		unlink latest > /dev/null 2>&1
	fi
	ln -s $JDK latest
	

	cd $PPWD

fi
