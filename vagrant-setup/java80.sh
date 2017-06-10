#!/bin/bash

JAVA=/usr/java
JDK=$JAVA/jdk1.8.0_112

# Install Java 8
if [ -d "$JDK" ]
	then

	echo "Java 8.0 is already installed, nothing done!"

else

	source /vagrant/vagrant-setup/include.sh

	# Install Java 8
	https://edelivery.oracle.com/akam/otn/java/jdk/8u112-b15/jdk-8u112-linux-x64.rpm
	RPM=jdk-8u112-linux-x64.rpm
	OTN=otn/java/jdk/8u112-b15
	if [ ! -f "$SETUP/cache/$RPM" ]
		then
		echo "Downloading JDK 8.0"
		wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "https://edelivery.oracle.com/akam/$OTN/$RPM" -P $SETUP/cache
	fi
	rpm -Uvh $SETUP/cache/$RPM

	# Install JAI 1.1.3
	# http://download.java.net/media/jai/builds/release/1_1_3/INSTALL.html
	cd $JAVA
	if [ ! -f "$SETUP/cache/jai-1_1_3-lib-linux-amd64-jdk.bin" ]
		then
		echo "Downloading JAI 1.1.3"
		wget http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64-jdk.bin -P $SETUP/cache
		chmod u+x -P $SETUP/cache/jai-1_1_3-lib-linux-amd64-jdk.bin
	fi
	cd $JDK
	echo "Installing JAI 1.1.3"
	echo -e "y\n" | $SETUP/cache/jai-1_1_3-lib-linux-amd64-jdk.bin

	cd /etc/alternatives
	if [ -L "jre" ]
	then
		unlink jre > /dev/null 2>&1
	fi
	if [ -L "jre" ]
	then
		unlink jre_exports > /dev/null 2>&1
	fi
	ln -s $JDK/jre jre

	# Required only if there was a previous Java 7 installation that isbeing replaced
	# BINS=( java keytool orbd pack200 rmid rmiregistry servertool tnameserv unpack200 )
	# for NM in "${BINS[@]}"
	# do
	# 	if [ -L "$NM" ]
	# 	then
	# 		unlink $NM.1.gz > /dev/null 2>&1
	# 	fi
	# 	ln -s $JDK/bin/$NM $NM
	# done

	cd $PPWD

fi
