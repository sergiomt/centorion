#!/bin/bash

SETUP="/vagrant/vagrant-setup"
PPWD=$PWD

if [ -f "/usr/src/Python-2.7.6" ]
then

	python --version
	echo "already installed. Nothing done!"

else

	source $SETUP/include.sh
	cd /usr/src
	wget_and_untar http://python.org/ftp/python/2.7.6/ Python-2.7.6.tgz
	cd Python-2.7.6
	sudo ./configure --prefix=/usr/local
	sudo make
	sudo make install

	yum install -y python-pip
	pip install --upgrade pip

fi

cd $PPWD
