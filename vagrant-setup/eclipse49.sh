#!/bin/bash

if [ -d "/usr/share/eclipse" ]
then

	echo "Eclipse is already installed. Nothing Done!"

else

	SETUP="/vagrant/vagrant-setup"
	PPWD=$PWD

	ECLIPSE_FILE="eclipse-java-2018-09-linux-gtk-x86_64"

	source $SETUP/include.sh
	cd /usr/share
	
	if [ ! -f "$SETUP/cache/$ECLIPSE_FILE.tar.gz" ]
		then
		echo "downloading $ECLIPSE_FILE.tar.gz"
		wget http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2018-09/R/$ECLIPSE_FILE.tar.gz&mirror_id=1156 -O $SETUP/cache/$ECLIPSE_FILE.tar.gz
	fi

	echo "untaring $ECLIPSE_FILE"
	tar -xzf $SETUP/cache/$ECLIPSE_FILE.tar.gz
	ln -s /usr/share/eclipse/eclipse /usr/bin/eclipse

	cp $SETUP/eclipse/eclipse-4.9.desktop /usr/share/applications

	if [[ $EUID -eq 0 ]]
	then
		chown -R vagrant.vagrant /usr/share/eclipse
	fi

	cd $PPWD
fi
