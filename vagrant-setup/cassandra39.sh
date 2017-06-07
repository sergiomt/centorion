#!/bin/bash

SETUP="/vagrant/vagrant-setup"
DATASTAX_INSTALL_DIR=/usr/share
DATASTAX_USER=you@domain.com
DATASTAX_PASS=

if rpm -q datastax-ddc &> /dev/null
then

	echo "Cassandra is already installed, nothing done!"

else

	source $SETUP/include.sh
	source $SETUP/java80.sh

	sudo yum install datastax-ddc

	perl -pi -e "s/#-Dcassandra.config=directory/-Dcassandra.config=file:\x2F\x2F\x2Fetc\x2Fcassandra\x2Fdefault.conf\x2Fcassandra.yaml/g" /etc/cassandra/default.conf/jvm.options
	perl -pi -e "s/export CASSANDRA_CONF=\x2Fetc\x2Fcassandra\x2Fconf/export CASSANDRA_CONF=\x2Fetc\x2Fcassandra\x2Fdefault\x2Econf/g" /etc/init.d/cassandra
	perl -pi -e "s/CASSANDRA_CONF=\x2Fetc\x2Fcassandra\x2Fconf/CASSANDRA_CONF=\x2Fetc\x2Fcassandra\x2Fdefault\x2Econf/g" /usr/share/cassandra/cassandra.in.sh

	# OpsCenter setup is disabled
	# cd $DATASTAX_INSTALL_DIR
	# echo "downloading opscenter.tar.gz"
	# curl --user $DATASTAX_USER:$DATASTAX_PASS -L http://downloads.datastax.com/enterprise/opscenter.tar.gz | tar xz
	# mv `find $DATASTAX_INSTALL_DIR -maxdepth 1 -name opscenter*` opscenter

	# Install Python 2.7.6 (required to execute cqlsh)
	source $SETUP/python276.sh

fi
