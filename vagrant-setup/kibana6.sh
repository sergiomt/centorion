#!/bin/bash

if rpm -q kibana &> /dev/null
then

	echo "Kibana is already installed, nothing done!"

else

	echo "Installing Kibana..."
	source /vagrant/vagrant-setup/include.sh
	rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
	cp $SETUP/elastic/kibana.repo /etc/yum.repos.d
	yum install kibana
	cd /usr/share/kibana
	su kibana -c "bin/kibana-plugin install x-pack" > /dev/null
	cd PPWD

fi