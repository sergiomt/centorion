#!/bin/bash

JAVA=/usr/java
JDK=$JAVA/jdk1.8.0_131

# Install Java 8
if [ -d "$JDK" ]
	then

	echo "Java 8.0 is already installed, nothing done!"

else

	source /vagrant/vagrant-setup/include.sh

	# Install Java 8
	# RPM=jdk-8u5-linux-x64.rpm
	# JDK=otn-pub/java/jdk/8u5-b13
	RPM=jdk-8u131-linux-x64.rpm
	JDK=otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163
	if [ ! -f "$SETUP/cache/jdk-8u5-linux-x64.rpm" ]
		then
		wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/$JDK/$RPM" -P $SETUP/cache
	fi
	rpm -Uvh $SETUP/cache/$RPM

	# Install JAI 1.1.3
	# http://download.java.net/media/jai/builds/release/1_1_3/INSTALL.html
	cd $JAVA
	if [ ! -f "$SETUP/cache/jai-1_1_3-lib-linux-amd64-jdk.bin" ]
		then
		wget http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64-jdk.bin -P $SETUP/cache
		chmod u+x -P $SETUP/cache/jai-1_1_3-lib-linux-amd64-jdk.bin
	fi
	cd $JDK
	echo -e "y\n" | $SETUP/cache/jai-1_1_3-lib-linux-amd64-jdk.bin

	cd /etc/alternatives
	unlink jre
	unlink jre_exports
	ln -s $JDK/jre jre

	BINS=( java keytool orbd pack200 rmid rmiregistry servertool tnameserv unpack200 )

	for NM in "${BINS[@]}"
	do
		if [ -h "$NM" ]
		then
			unlink $NM.1.gz > /dev/null 2>&1
		fi
		ln -s $JDK/bin/$NM $NM
	done

	cd $PPWD

fi
