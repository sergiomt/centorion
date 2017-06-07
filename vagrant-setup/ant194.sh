#!/bin/bash

if [ -d "/usr/local/ant" ]
then

	echo "Ant is already installed, nothing done!"

else

	echo "Installing Ant 1.94..."
	source /vagrant/vagrant-setup/include.sh
	cd /usr/local
	ANT=apache-ant-1.9.4
	wget_and_untar http://apache.mirror.anlx.net//ant/binaries/ $ANT-bin.tar.gz
	mv $ANT ant
	cd $PPWD

fi

