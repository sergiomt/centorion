#!/bin/bash

# Install Nagios Core 4.1.1

SETUP="/vagrant/vagrant-setup"
PPWD=$PWD

if [ -d "/usr/share/nagios" ]
	then

	echo "Nagios is already installed, nothing done!"

else

	source $SETUP/include.sh
	
	sudo yum install -y gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel xinetd unzip

	if getent passwd nagios > /dev/null 2>&1; then
		echo "nagios user already exists"
	else
		# Create a user for running Tomcat
		sudo useradd nagios
		sudo groupadd nagcmd
		sudo usermod -a -G nagcmd nagios
		echo -e "nagpasswd4\nnagpasswd4\n" | passwd nagios
		# In order to issue external commands via the web interface to Nagios, the web server user, apache, must be added to the nagcmd group
		if getent passwd apache > /dev/null 2>&1; then
			sudo usermod -G nagcmd apache
		fi
	fi

	cd /usr/share
	wget_and_untar https://assets.nagios.com/downloads/nagioscore/releases/ nagios-4.1.1.tar.gz
	mv nagios-4.1.1 nagios
	cd nagios
	./configure --with-command-group=nagcmd 
	make all
	sudo make install
	sudo make install-commandmode
	sudo make install-init
	sudo make install-config
	sudo make install-webconf
		
	wget_and_untar http://nagios-plugins.org/download/ nagios-plugins-2.1.1.tar.gz
	mv nagios-plugins-2.1.1 plugins
	cd plugins
	./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
	make
	sudo make install

  cd ..
	wget_and_untar http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/ nrpe-2.15.tar.gz
	mv nrpe-2.15 nrpe
	cd nrpe
	./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
	make all
  sudo make install
  sudo make install-xinetd
  sudo make install-daemon-config

	sudo perl -pi -e "s/#?\t*\s*only_from\s*=\s*127\\x2E0\\x2E0\\x2E1/\tonly_from = 127.0.0.1 192.168.101.110/g" /etc/xinetd.d/nrpe

	sudo systemctl restart xinetd.service

	# Configure Nagios
	sudo mkdir /usr/local/nagios/etc/servers
	sudo chown nagios:nagios /usr/local/nagios/etc/servers/
	sudo perl -pi -e "s/#cfg_dir=\\x2Fusr\\x2Flocal\\x2Fnagios\\x2Fetc\\x2Fservers/cfg_dir=\\x2Fusr\\x2Flocal\\x2Fnagios\\x2Fetc\\x2Fservers/g" /usr/local/nagios/etc/nagios.cfg

	sudo su nagios -c "cat $SETUP/nagios/commands.cfg >> /usr/local/nagios/etc/objects/commands.cfg"
	
	sudo htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagpasswd4
	
	# Nagios is ready,now re-start Apache
	sudo systemctl daemon-reload
	sudo systemctl start nagios.service
	sudo systemctl restart httpd.service

	# To enable Nagios to start on server boot, run this command:
	# sudo chkconfig nagios on
	
	# Optional: Restrict Access by IP Address
	# If you want to restrict the IP addresses that can access the Nagios web interface, you will want to edit the Apache configuration file:
	# sudo vi /etc/httpd/conf.d/nagios.conf
	# Find and comment the following two lines by adding # symbols in front of them:
	# Order allow,deny
	# Allow from all
	# Then uncomment the following lines, by deleting the # symbols, and add the IP addresses or ranges (space delimited) that you want to allow to in the Allow from line:
	# Order deny,allow
	# Deny from all
	# Allow from 127.0.0.1
	# As these lines will appear twice in the configuration file, so you will need to perform these steps once more.
	# Save and exit.

	cd $PPWD

fi