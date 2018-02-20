#!/bin/bash

if [[ $EUID -eq 0 ]]
then

	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh

	if isinstalled esl-erlang
	then
		elixir --version
	else
		source $SETUP/erlang.sh
	fi

	wget_and_cp https://dl.bintray.com/rabbitmq/all/rabbitmq-server/3.7.3/ rabbitmq-server-3.7.3-1.el7.noarch.rpm
	rpm --import https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc
	yum -y install $SETUP/cache/rabbitmq-server-3.7.3-1.el7.noarch.rpm

else

	echo "RabbitMQ must be installed as root. Type sudo ./rabbitmq373.sh for executing the script."

fi