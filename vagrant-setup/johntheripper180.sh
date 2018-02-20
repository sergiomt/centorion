#!/bin/bash

if [[ $EUID -eq 0 ]]
then

	SETUP="/vagrant/vagrant-setup"
	PPWD=$PWD
	source $SETUP/include.sh

	cd /usr/share
	wget_and_untar http://www.openwall.com/john/j/ john-1.8.0.tar.gz
	mv john-1.8.0 john
	cd john
	chown -R vagrant.vagrant john
	cd john/src
	su vagrant -c "make clean linux-x86-64"

else

	echo "John the Ripper must be installed as root. Type sudo ./johntheripper180.sh for executing the script."

fi