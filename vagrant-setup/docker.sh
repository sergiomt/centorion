#!/bin/bash

SETUP="/vagrant/vagrant-setup"
source $SETUP/include.sh

if isinstalled docker-ce
then

	echo "Docker is already installed. Nothing Done!"

else

	if [[ $EUID -eq 0 ]]
	then

		yum install -y yum-utils
		yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		yum install -y docker-ce
		groupadd docker
		usermod -aG docker vagrant
		systemctl enable docker
		systemctl start docker
		echo "Docker installation completed. You must log out and log in again in order to be able to invoke docker with non root user."

	else

		echo "Docker must be installed as root. Type sudo ./docker.sh for executing the script."

	fi
fi
