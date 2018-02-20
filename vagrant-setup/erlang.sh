#!/bin/bash

if [[ $EUID -eq 0 ]]
then

	if [ -z "$JAVA_HOME" ]
	then
		echo "Warning: JAVA_HOME is not set. Have you installed already Java 8?"
	fi

	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh

	source $SETUP/openssl102.sh

	yum -y install epel-release
	# Required gcc gcc-c++ must have been already installed by setup.sh
	yum -y install glibc-devel make ncurses-devel autoconf wxBase.x86_64
	wget_and_cp http://packages.erlang-solutions.com/ erlang-solutions-1.0-1.noarch.rpm
	sudo rpm -Uvh $SETUP/cache/erlang-solutions-1.0-1.noarch.rpm
	yum -y install esl-erlang
	
	# Install Elixir manually as the version in the repo is far behind
	mkdir /usr/share/elixir
	git clone https://github.com/elixir-lang/elixir.git /usr/share/elixir
	cd /usr/share/elixir
	make clean test
	sudo ln -s /usr/share/elixir/bin/iex /usr/local/bin/iex
	sudo ln -s /usr/share/elixir/bin/mix /usr/local/bin/mix
	sudo ln -s /usr/share/elixir/bin/elixir /usr/local/bin/elixir
	sudo ln -s /usr/share/elixir/bin/elixirc /usr/local/bin/elixirc	

else

	echo "Erlang must be installed as root. Type sudo ./erlang.sh for executing the script."

fi
