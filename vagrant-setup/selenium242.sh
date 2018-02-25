#!/bin/bash

SETUP=/vagrant/vagrant-setup
cd $SETUP

source $SETUP/include.sh

# Selenium Standalone Server
yum install -y xorg-x11-server-Xvfb firefox
cd /usr/share
mkdir selenium
cd selenium
wget_and_cp http://selenium-release.storage.googleapis.com/2.42/ selenium-server-standalone-2.42.2.jar .
