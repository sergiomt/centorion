#!/bin/bash

if [ -d "/opt/openfire" ]
	then
	echo "Openfire is already installed, nothing done!"
else
	yum install -y gtk2.i686
	yum install -y libXtst.i686
	if [ ! -f "/vagrant/vagrant-setup/cache/openfire-3.9.3-1.i386.rpm" ]
	then
		wget http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire-3.9.3-1.i386.rpm
		mv openfire-3.9.3-1.i386.rpm /vagrant/vagrant-setup/cache/openfire-3.9.3-1.i386.rpm
	else
		yum localinstall -y /vagrant/vagrant-setup/cache/openfire-3.9.3-1.i386.rpm
	fi
	# Use the existing JRE and not the embeded JRE
	rm -r -f /opt/openfire/jre
	iptables -A INPUT -p tcp --dport 9090 -j ACCEPT
	iptables -A INPUT -p tcp --dport 9091 -j ACCEPT
	service iptables save
	service iptables restart
	service openfire start
fi