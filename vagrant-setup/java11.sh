#!/bin/bash

JAVA=/usr/java
JDK=$JAVA/jdk-11.0.1

# Install Java 11
if [ -d "$JDK" ]
	then

	echo "Java 11.0 is already installed, nothing done!"

else

	source /vagrant/vagrant-setup/include.sh

	# Install Java 11

	OPENJDK=openjdk-11.0.1_linux-x64_bin.tar.gz

	cd /usr/java
	echo "Downloading JDK 11.0"
	wget_and_untar https://download.java.net/java/GA/jdk11/13/GPL/ $OPENJDK

	if [ -L "latest" ]
	then
		unlink latest > /dev/null 2>&1
	fi
	ln -s $JDK latest

	cd $PPWD

fi
