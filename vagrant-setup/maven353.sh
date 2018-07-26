#!/bin/bash

SETUP=/vagrant/vagrant-setup

# Install Maven
if [ -d "/usr/local/maven" ]
	then

	echo "Maven is already installed, nothing done!"

else

	echo "Installing Maven 3.5.3..."
	source /vagrant/vagrant-setup/include.sh
	cd /usr/local
	MAVEN_FILE="apache-maven-3.5.3"
	wget_and_untar http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/3.5.3/binaries/ $MAVEN_FILE-bin.tar.gz maven.tar.gz
	mkdir maven
	cd $MAVEN_FILE
	mv * ../maven
	cd ..
	rmdir $MAVEN_FILE
	cd $PPWD

	ln -s /vagrant/vagrant-setup/.m2 /home/vagrant/.m2
fi