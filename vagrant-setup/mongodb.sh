#!/bin/bash

# Install MongoDB
# See https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/

SETUP="/vagrant/vagrant-setup"
source $SETUP/include.sh

if isinstalled mongodb-org
	then

	echo "MongoDB is already installed, nothing done!"

else

	if [ ! -f "/etc/yum.repos.d/mongodb-org-4.0.repo" ]
	then
		cp $SETUP/mongodb/mongodb-org-4.0.repo /etc/yum.repos.d/mongodb-org-4.0.repo
	fi
	
	sudo yum install -y mongodb-org
	
	# To install a specific release of MongoDB, specify each component package individually and append the version number to the package name, as in the following example:
	# sudo yum install -y mongodb-org-4.0.2 mongodb-org-server-4.0.2 mongodb-org-shell-4.0.2 mongodb-org-mongos-4.0.2 mongodb-org-tools-4.0.2
	
	sudo service mongod start
	
	if grep -q "[initandlisten] waiting for connections on port" "/var/log/mongodb/mongod.log"
		then
		echo "ERROR: MongoDB failed to start check /var/log/mongodb/mongod.log"

	else
		echo "MongoDB successfully installed and started."
	fi
fi
