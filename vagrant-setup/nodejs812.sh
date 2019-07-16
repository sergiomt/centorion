#!/bin/bash

# Install NodeJS 8.12.2

SETUP="/vagrant/vagrant-setup"
PPWD=$PWD

if [ -d "/usr/share/nodejs" ]
	then

	echo "NodeJS is already installed, nothing done!"

else

	source $SETUP/include.sh

	cd /usr/share
	wget_and_untar http://nodejs.org/dist/v8.12.0/ node-v8.12.0-linux-x64.tar.gz
	mv node-v8.12.0-linux-x64 nodejs
	cd /usr/bin
	ln -s /usr/share/nodejs/bin/node node
	ln -s /usr/share/nodejs/bin/npm npm
	cd /usr/share/nodejs/bin
	./node --version
	./npm config set strict-ssl false
	./npm -g install bower concurrently express express-generator supervisor typescript tslint
	cd /usr/bin
	ln -s /usr/share/nodejs/bin/bower bower
	ln -s /usr/share/nodejs/bin/express express
	ln -s /usr/share/nodejs/bin/tsc tsc
	ln -s /usr/share/nodejs/bin/concurrently concurrently

	cd $PPWD

fi