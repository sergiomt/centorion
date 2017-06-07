#!/bin/bash

# Install HBase 1.1.2
# See http://hbase.apache.org/book.html

SETUP="/vagrant/vagrant-setup"
PPWD=$PWD

if [ -d "/usr/share/hbase" ]
	then

	echo "HBase is already installed, nothing done!"

else

	source $SETUP/include.sh

	# yum install -y bzip2 gzip lzo-devel zlib-devel

	source $SETUP/hadoop251.sh
	source $SETUP/zookeeper346.sh

	su - hadoop -c "/usr/share/hadoop/bin/hadoop fs -mkdir /hbase"

	cd /usr/share
	HBASE_FILE="hbase-1.1.2"
	wget_and_untar http://mirror.ox.ac.uk/sites/rsync.apache.org/hbase/1.1.2/ $HBASE_FILE-bin.tar.gz
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
	perl -pi -e "s/# export JAVA_HOME=\x2Fusr\x2Fjava\x2Fjdk1.6.0\x2F/export JAVA_HOME=\x2Fusr\x2Fjava\x2Flatest\x2F/g" ./hbase/conf/hbase-env.sh
	mkdir /usr/share/hbase/zookeeper
	ln -s /usr/share/hadoop/etc/hadoop/hdfs-site.xml /usr/share/hbase/conf/hdfs-site.xml
	chown -Rf hadoop.hadoop hbase
	chmod +r hbase
	chmod +x hbase/conf
	chmod -R +r hbase/conf

	cp $SETUP/hbase/init.d/hbase /etc/init.d/hbase
	chmod 755 /etc/init.d/hbase

	cd $PPWD

fi