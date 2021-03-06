#!/bin/bash

if rpm -q elasticsearch &> /dev/null
then

	echo "Elasticsearch is already installed, nothing done!"

else

	echo "Installing Elasticsearch..."
	source /vagrant/vagrant-setup/include.sh
	rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
	cp $SETUP/elastic/elasticsearch.repo /etc/yum.repos.d
	yum install elasticsearch
	cd /usr/share/elasticsearch
	bin/elasticsearch-plugin install x-pack
	cd PPWD

fi