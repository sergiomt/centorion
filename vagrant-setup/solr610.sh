#!/bin/bash

if [ -d "/usr/local/solr" ]
then

	echo "Solr is already installed, nothing done!"

else

		SETUP="/vagrant/vagrant-setup"
		source $SETUP/include.sh

		PPWD=$PWD
		cd /usr/share

		yum install -y lsof

		SOLR=solr-6.1.0

		wget_and_cp http://apache.mirror.anlx.net/lucene/solr/6.1.0/ $SOLR.tgz

		iptables -A INPUT -p tcp --dport 8983 -j ACCEPT
		service iptables save
		systemctl restart iptables

		source $SETUP/install_solr_service.sh $SETUP/cache/$SOLR.tgz -i /usr/share

	cd $PPWD
fi