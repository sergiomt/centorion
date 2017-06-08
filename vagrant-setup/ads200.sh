#!/bin/bash

VER=apacheds-2.0.0-M17
ADS=apacheds-2.0.0-M17-64bit.bin

if [ -d "/opt/$VER" ]
	then

	echo "Apache Directory Service 2.0 is already installed, nothing done!"

else

  source /vagrant/vagrant-setup/include.sh
	wget_and_make_executable http://apache.mirrors.timporter.net/directory/apacheds/dist/2.0.0-M17/ $ADS
	echo -e "yes\n\n\n\n\n\n\n" | $SETUP/cache/$ADS
	rm $ADS
	mv /etc/init.d/$VER-default /etc/init.d/apacheds
	
	# apacheds script gets @user@ as OS user to run the service and it does not work
	# replace RUN_AS_USER="@user@" with RUN_AS_USER="apacheds" to make it work
	perl -pi -e 's/RUN_AS_USER\x3D\x22\x40user\x40\x22/RUN_AS_USER\x3D\x22apacheds\x22/g' /opt/$VER/bin/apacheds

	# Change web server ports from 8080 to 8000 and 8443 to 8400 to avoid clashing with Tomcat
	perl -pi -e 's/ads-systemport: 8080/ads-systemport: 8000/g' /var/lib/$VER/default/conf/config.ldif
	perl -pi -e 's/ads-systemport: 8443/ads-systemport: 8400/g' /var/lib/$VER/default/conf/config.ldif

	# Add users partition
	# mkdir /var/lib/$VER/default/partitions/users
	# cat $SETUP/ldap/users.ldif >> /var/lib/$VER/default/conf/config.ldif

	iptables -A INPUT -p tcp --dport 10389 -j ACCEPT
	service iptables save
	systemctl restart iptables

	service apacheds start default
fi