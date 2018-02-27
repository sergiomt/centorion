#!/bin/bash

SETUP=/vagrant/vagrant-setup
PPWD=$PWD

source $SETUP/include.sh

cd /usr/local
wget_and_unzip https://services.gradle.org/distributions/ gradle-3.4.1-bin.zip
mv gradle-3.4.1 gradle

cd $PPWD
