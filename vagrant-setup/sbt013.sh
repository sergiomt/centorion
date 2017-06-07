#!/bin/bash

if [ -d "/usr/local/sbt" ]
	then

	echo "sbt is already installed, nothing done!"

else

	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh

	PPWD=$PWD
	cd /usr/local

	wget_and_untar https://dl.bintray.com/sbt/native-packages/sbt/0.13.13/ sbt-0.13.13.tgz
	mv sbt-launcher-packaging-0.13.13 sbt
	cd $PPWD
fi
