#!/bin/bash

if [ -d "/usr/share/eclipse" ]
then

	echo "Eclipse is already installed. Nothing Done!"

else

	SETUP="/vagrant/vagrant-setup"
	PPWD=$PWD

	ECLIPSE_FILE="eclipse-java-oxygen-1a-linux-gtk-x86_64"

	source $SETUP/include.sh
	cd /usr/share
	wget_and_untar http://ftp.jaist.ac.jp/pub/eclipse/technology/epp/downloads/release/oxygen/1a/ $ECLIPSE_FILE.tar.gz
	ln -s /usr/share/eclipse/eclipse /usr/bin/eclipse
	cp --remove-destination $SETUP/eclipse/eclipse.ini /usr/share/eclipse
	cp $SETUP/eclipse/eclipse-4.7.desktop /usr/share/applications

	if [[ $EUID -eq 0 ]]
	then
		chown -R vagrant.vagrant /usr/share/eclipse
	fi

	cd $PPWD
fi
