#!/bin/bash

if [[ $EUID -eq 0 ]]
then

	PPWD=$PWD
	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh

	yum -y install python-pip
	pip install --upgrade pip
	pip install virtualenv
	mkdir /home/vagrant/pythonprojects
	chown vagrant.vagrant /home/vagrant/pythonprojects
	cd /home/vagrant/pythonprojects
	virtualenv env1
	chown -R vagrant.vagrant env1
	su vagrant -c "source env1/bin/activate"
	su vagrant -c "pip install django"
	django-admin --version
	su vagrant -c "deactivate"

	cd $PPWD

else

	echo "Django must be installed as root. Type sudo ./django.sh for executing the script."

fi
