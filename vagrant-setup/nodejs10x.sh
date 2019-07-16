#!/bin/bash

# Install NodeJS

SETUP="/vagrant/vagrant-setup"
PPWD=$PWD

if [ -d "/usr/share/nodejs" ]
	then

	echo "NodeJS is already installed, nothing done!"

else

	source $SETUP/include.sh

	curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -

	yum install -y nodejs
	./node --version

	cd $PPWD

fi