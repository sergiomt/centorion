#!/bin/bash

if [ -d "/usr/share/intellij" ]
then

	echo "IntelliJ is already installed, nothing done!"

else

	echo "Installing IntelliJ 3.4..."
	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh
	cd /usr/share
	wget_and_untar https://download.jetbrains.com/idea/ ideaIC-2017.3.4-no-jdk.tar.gz
	mv idea-IC-173.4548.28 intellij
	if [[ $EUID -eq 0 ]]
	then
		chown -R vagrant.vagrant /usr/share/intellij
	fi
	ln -s /usr/share/intellij/bin/idea.sh /usr/bin/idea
	cp $SETUP/intellij/intellij-3.4.desktop /usr/share/applications
	cd $PPWD

fi
