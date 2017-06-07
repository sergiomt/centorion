#!/bin/bash

# Install NodeJS 6.2.2

SETUP="/vagrant/vagrant-setup"
PPWD=$PWD

if [ -d "/usr/share/nodejs" ]
	then

	echo "NodeJS is already installed, nothing done!"

else

	source $SETUP/include.sh

	cd /usr/share
	wget_and_untar http://nodejs.org/dist/v6.2.2/ node-v6.2.2-linux-x64.tar.gz
	mv node-v6.2.2-linux-x64 nodejs
	cd /usr/bin
	ln -s /usr/share/nodejs/bin/node node
	ln -s /usr/share/nodejs/bin/npm npm
	cd /usr/share/nodejs/bin
	./node --version
	./npm -g install bower concurrently express express-generator lite-server supervisor typescript
	cd /usr/bin
	ln -s /usr/share/nodejs/bin/bower bower
	ln -s /usr/share/nodejs/bin/express express
	ln -s /usr/share/nodejs/bin/tsc tsc
	ln -s /usr/share/nodejs/bin/concurrently concurrently
	ln -s /usr/share/nodejs/bin/lite-server lite-server

	cd $PPWD

fi