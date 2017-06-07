#!/bin/bash

source /vagrant/vagrant-setup/include.sh

# Selenium Standalone Server
yum install -y xorg-x11-server-Xvfb firefox
cd /usr/share
mkdir selenium
cd selenium
wget_and_cp http://selenium-release.storage.googleapis.com/2.42/ selenium-server-standalone-2.42.2.jar .

# To start Selenium Server do:
# Xvfb :1 -screen 0 800x600x24&
# export DISPLAY=localhost:1.0
# java -jar selenium-server-standalone-2.42.2.jar &
