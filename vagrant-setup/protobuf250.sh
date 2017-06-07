#!/bin/bash

# Install Protocol Buffers 2.5.0

PPWD=$PWD
if [ -d "/usr/share/protobuf" ]
	then
	echo "Protocol Buffers is already installed."
else
	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh
	echo "Making Protocol Buffers"
	yum install -y bzip2
	cd /usr/share
	PROTOB=protobuf-2.5.0
	wget_and_unbz2 http://protobuf.googlecode.com/files/ $PROTOB.tar
	mv $PROTOB protobuf
	cd protobuf
	./configure
	make
	make install
	ldconfig
	cd $PPWD
fi
