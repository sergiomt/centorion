#!/bin/bash

# You need to have an SSH key with name id_dsa at /vagrant/vagrant-setup/.ssh or ~/.ssh
# This script will copy id_dsa to ~/.ssh
# This SSH key must be already authorized to clone and push to Clocial repositories

SETUP="/vagrant/vagrant-setup"
MAVEN="/usr/local/maven"

export M2_HOME=$MAVEN
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

cd /vagrant

# Clone and compile source code
cd /vagrant

if [ ! -d "/vagrant/workspace" ]
then
	mkdir workspace
	chown vagrant ./workspace
	chmod 774 ./workspace
fi

if [ -d "/vagrant/workspace/knowgate9" ]
then
  echo "/vagrant/workspace/knowgate9 already exists, skipping git clone for this repository"
else
  cd /vagrant/workspace
  git clone https://github.com/sergiomt/knowgate9.git
fi

if [ -d "$MAVEN" ]
then
	cd /vagrant/workspace/knowgate9/knowgate-base
  mvn install -DskipTests
  cd ../knowgate-stripes
	mvn install -DskipTests
	cd ../knowgate-extws
  mvn install -DskipTests
	cd ../knowgate-bulkmailer
	mvn install -DskipTests
fi

	# Check that all the .jar files have been generated

	if [ -f "/vagrant/workspace/knowgate9/knowgate-base/target/core-9.0.jar" ]
	then
		echo "KnowGate Base libraries successfully compiled and installed at Maven"
	else
		echo "ERROR: Failed to compile or install KnowGate Base libraries"
	fi
	if [ -f "/vagrant/workspace/knowgate9/knowgate-stripes/target/stripes-9.0.jar" ]
	then
		echo "KnowGate Stripes Wrapper successfully compiled and installed at Maven"
	else
		echo "ERROR: Failed to compile or install KnowGate Stripes Wrapper"
	fi
	if [ -f "/vagrant/workspace/knowgate9/knowgate-extws/target/extws-9.0.jar" ]
	then
		echo "KnowGate Extended Web Services successfully compiled and installed at Maven"
	else
		echo "ERROR: Failed to compile or install KnowGate Extended Web Services"
	fi
	if [  -f "/vagrant/workspace/knowgate9/knowgate-bulkmailer/target/knowgate-bulkmailer-1.0.jar" ]
	then
		echo "KnowGate Bulk Mailier successfully compiled and installed at Maven"
	else
		echo "ERROR: Failed to compile or install KnowGate Bulk Mailier"
	fi
fi
