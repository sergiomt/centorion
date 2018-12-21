#!/bin/bash

# Install HBase 2.1.0
# See http://hbase.apache.org/book.html

SETUP="/vagrant/vagrant-setup"
PPWD=$PWD

if [ -d "/usr/share/hbase" ]
	then

	echo "HBase is already installed, nothing done!"

else

	source $SETUP/include.sh

	# yum install -y bzip2 gzip lzo-devel zlib-devel

	source $SETUP/hadoop277.sh
	source $SETUP/zookeeper3410.sh

	if ps ax | grep -v grep | grep $SERVICE > /dev/null
	then
		echo "hadoop service is running"
	else
		echo "Starting hadoop service"
		service hadoop start
	fi

	cd /usr/share
	HBASE_FILE="hbase-2.1.0"
	wget_and_untar http://apache.mirror.anlx.net/hbase/2.1.0/ $HBASE_FILE-bin.tar.gz
	mkdir hbase
	mkdir hbase/logs
	cd $HBASE_FILE
	mv * ../hbase
	cd ..
	rmdir $HBASE_FILE
	echo -e "\nLD_LIBRARY_PATH=/usr/local/lib\nexport LD_LIBRARY_PATH\n" >> ./hbase/conf/hbase-env.sh
	rm ./hbase/conf/hbase-site.xml
	cp $SETUP/hbase/conf/hbase-site.xml ./hbase/conf/hbase-site.xml
	perl -pi -e "s/# export HBASE_MANAGES_ZK=true/export HBASE_MANAGES_ZK=false/g" ./hbase/conf/hbase-env.sh
	perl -pi -e "s/# export JAVA_HOME=\x2Fusr\x2Fjava\x2Fjdk1.8.0\x2F/export JAVA_HOME=\x2Fusr\x2Fjava\x2Flatest\x2F/g" ./hbase/conf/hbase-env.sh
	mkdir /usr/share/hbase/zookeeper
	ln -s /usr/share/hadoop/etc/hadoop/hdfs-site.xml /usr/share/hbase/conf/hdfs-site.xml
	chown -Rf hadoop.hadoop hbase
	chmod +r hbase
	chmod +x hbase/conf
	chmod -R +r hbase/conf

	cp $SETUP/hbase/init.d/hbase /etc/init.d/hbase
	chmod 755 /etc/init.d/hbase

	echo "Creating -hbase directory in HDFS"
	su - hadoop -c "/usr/share/hadoop/bin/hadoop fs -mkdir /hbase"

	cd $PPWD

	# Open Port 16020
	iptables -A INPUT -p tcp --dport 16020 -j ACCEPT
	service iptables save
	systemctl restart iptables

fi