#!/bin/bash

SETUP=/vagrant/vagrant-setup
cd $SETUP

if [ -z "$SDKMAN_DIR" ]
then
	source $SETUP/sdkman.sh
fi

sdk install kotlin
