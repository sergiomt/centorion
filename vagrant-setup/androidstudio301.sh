#!/bin/bash

if [ -d "/usr/share/androidstudio" ]
then

	echo "Android Studio is already installed. Nothing Done!"

else

	SETUP="/vagrant/vagrant-setup"
	PPWD=$PWD

	source $SETUP/include.sh
	cd /usr/share

	wget_and_unzip https://dl.google.com/dl/android/studio/ide-zips/3.0.1.0/ android-studio-ide-171.4443003-linux.zip

	# cp $SETUP/androidstudio/android-studio-3.0.1.desktop /usr/share/applications

	ln -s /usr/share/android-studio/bin/studio.sh /usr/bin/studio
	cp $SETUP/androidstudio/android-studio-3.0.1.desktop /usr/share/applications

	if [[ $EUID -eq 0 ]]
	then
		chown -R vagrant.vagrant /usr/share/android-studio
	fi

	cd $PPWD

fi
