#!/bin/bash

if rpm -q logstash &> /dev/null
then

	echo "Logstash is already installed, nothing done!"

else

	echo "Installing Logstash..."
	source /vagrant/vagrant-setup/include.sh
	rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
	cp $SETUP/elastic/logstash.repo /etc/yum.repos.d
	yum install logstash

fi