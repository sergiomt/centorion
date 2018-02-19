#!/bin/bash

if [ -z "$GROOVY_HOME" ]
	then

	echo "Groovy is already installed, nothing done!"

else

	if [ -z "$JAVA_HOME" ]
	then
		echo "Warning: JAVA_HOME is not set. Have you installed already Java?"
	fi

	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh

	PPWD=$PWD
	cd /usr/local

	GROOVY_BIN=apache-groovy-binary-2.4.13
	wget_and_unzip https://bintray.com/artifact/download/groovy/maven/ $GROOVY_BIN.zip
	mv groovy-2.4.13 groovy
	echo -e "\nGROOVY_HOME=/usr/local/groovy" >> /home/vagrant/.bashrc
fi