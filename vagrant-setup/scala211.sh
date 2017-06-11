#!/bin/bash

SETUP="/vagrant/vagrant-setup"

echo "Installing Scala 2.11..."
if [ -f "$SETUP/cache/$2" ]
	then
	yum localinstall -y $SETUP/cache/scala-2.11.0.rpm
else
	yum localinstall -y http://www.scala-lang.org/files/archive/scala-2.11.0.rpm
fi
