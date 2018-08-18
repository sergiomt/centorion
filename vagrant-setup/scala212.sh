#!/bin/bash

SETUP="/vagrant/vagrant-setup"
PACKAGE="scala-2.12.6"

source $SETUP/include.sh

if isinstalled $PACKAGE
then
	echo "Scala 2.12.6 is already installed. Nothing Done!"
else
	echo "Installing Scala 2.12.6 ..."
	if [ -f "$SETUP/cache/$2" ]
	then
		yum localinstall -y $SETUP/cache/$PACKAGE.rpm
	else
		yum localinstall -y http://www.scala-lang.org/files/archive/$PACKAGE.rpm
	fi
fi
