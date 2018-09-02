#!/bin/bash

# Install DCEVM for dynamic Java class reloading from Tomcat
# Disable this for a production server
# I may take about half an hour to compile
# The VM need to have at least 1.5Gb of RAM assigned.
# https://github.com/dcevm/dcevm
if [ -d "/usr/java/dcevm" ]
	then
	echo "DCEVM is already installed, nothing done!"
else
	sudo yum install -y libstdc++-static
	cd /usr/java
	git clone https://github.com/dcevm/dcevm.git
	cd dcevm
	sudo ./gradlew patch
	sudo ./gradlew installProduct -PtargetJre=/usr/java/jdk1.8.0_162/jre
fi