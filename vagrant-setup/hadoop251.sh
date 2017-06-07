#!/bin/bash

# Install Hadoop 2.5.1 from source

if [ -d "/usr/share/hadoop" ]
	then

	echo "Hadoop is already installed, nothing done!"

else

	echo "Installing Hadoop 2.5.1..."

	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh

	PPWD=$PWD
	cd /usr/share

	HADOOP=hadoop-2.5.1

	if [ -f "/usr/local/lib/libhadoop.so" ]
	then
		echo "Hadoop native libraries found at /usr/local/lib"
	else
		if [ -f "/vagrant/vagrant-setup/hadoop/native/libhadoop.so" ]
		then
				echo "Using precompiled native libraries in cache"
				cp -u $SETUP/hadoop/native/*.* /usr/local/lib
				ln -s $JAVA_HOME/jre/lib/amd64/server/libjvm.so /usr/local/lib/libjvm.so
				ldd /usr/local/lib/libhadoop.so
		else
			if [ -d "/usr/local/maven" ]
			then
				# yum install -y cmake
				# If Protocol Buffers is not installed then
				# "[ERROR] Could not find goal 'protoc' in plugin"
				# is raised when trying to execute mvn compile
				if [ ! -d "/usr/share/protobuf" ]
				then
					source $SETUP/protobuf250.sh
				fi
				wget_and_untar https://archive.apache.org/dist/hadoop/core/$HADOOP/ $HADOOP-src.tar.gz
				cd $HADOOP-src
				/usr/local/maven/bin/mvn install -Pnative
				cp -u ./hadoop-common-project/hadoop-common/target/native/target/usr/local/lib/*.* /usr/local/lib
				ln -s $JAVA_HOME/jre/lib/amd64/server/libjvm.so /usr/local/lib/libjvm.so
				ldd /usr/local/lib/libhadoop.so
				cd ..
				rm -R -f $HADOOP-src
			else
				echo "Maven not found, skipping Hadoop native libraries generation"
			fi
		fi
	fi

	# mvn package raises plenty of errors when trying to build Hadoop 2.5.1 from source
	# so after generating native libraries download the corresponding binary distribution and install from it.
	# See http://tecadmin.net/setup-hadoop-2-4-single-node-cluster-on-linux/
	# See http://www.alexjf.net/blog/distributed-systems/hadoop-yarn-installation-definitive-guide/

	wget_and_untar https://archive.apache.org/dist/hadoop/core/$HADOOP/ $HADOOP.tar.gz
	mv $HADOOP hadoop

	cp $SETUP/hadoop/core-site.xml ./hadoop/etc/hadoop/
	cp $SETUP/hadoop/hdfs-site.xml ./hadoop/etc/hadoop/
	cp $SETUP/hadoop/mapred-site.xml ./hadoop/etc/hadoop/

	if getent passwd hadoop > /dev/null 2>&1; then
		echo "hadoop user already exists"
	else
		groupadd hadoop
		adduser hadoop -K MAIL_DIR=/dev/null -g hadoop
		# password login is disabled at /etc/ssh/sshd_config
		# echo -e "hadoop\nhadoop\n" | passwd hadoop
	fi

	# hadoop user must be authorized for SSH
	perl -pi -e "s/#\s*Port 22/Port 22/g" /etc/ssh/sshd_config
	service sshd restart
	# if ! grep -q "\nPort 9001" "/etc/ssh/sshd_config"; then
		# perl -pi -e "s/#\s*Port 22/Port 22\nPort 9001/g" /etc/ssh/sshd_config
	# fi
	# Port 9001 must be open
	iptables -A INPUT -p tcp --dport 9001 -j ACCEPT
	service iptables restart

	if ! grep -q "\nJAVA_HOME" "/usr/share/hadoop/bin/hadoop"; then
		perl -pi -e "s/DEFAULT_LIBEXEC_DIR=/JAVA_HOME=\x2Fusr\x2Fjava\x2Flatest\nDEFAULT_LIBEXEC_DIR=/g" /usr/share/hadoop/bin/hadoop
	fi
	if ! grep -q "-Djava\x2Elibrary\x2Epath" "/usr/share/hadoop/bin/hadoop"; then
		perl -pi -e "s/HADOOP_OPTS=\x22\x24HADOOP_OPTS \x24HADOOP_CLIENT_OPTS\x22/HADOOP_OPTS=\x22\x24HADOOP_OPTS \x24HADOOP_CLIENT_OPTS\x22\n    HADOOP_OPTS=\x22\x24HADOOP_OPTS -Djava\x2Elibrary\x2Epath=\x2Fusr\x2Fshare\x2Fhadoop\x2Flib\x2Fnative\x22/g" /usr/share/hadoop/bin/hadoop
	fi

	mkdir /usr/share/hadoop/logs
	chown hadoop /usr/share/hadoop/logs
	chgrp hadoop /usr/share/hadoop/logs
	su - hadoop -c "mkdir /home/hadoop/tmp"
	su - hadoop -c "mkdir -p /home/hadoop/hadoopdata/hdfs/namenode"
	su - hadoop -c "mkdir -p /home/hadoop/hadoopdata/hdfs/datanode"
	su - hadoop -c "mkdir /home/hadoop/.ssh"
	su - hadoop -c "echo | ssh-keygen -t rsa -f ~/.ssh/id_rsa"
	su - hadoop -c "cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys"
	chown hadoop /home/hadoop/.ssh/authorized_keys
	chgrp hadoop /home/hadoop/.ssh/authorized_keys
	chmod 0700 /home/hadoop/.ssh/
	chmod 0600 /home/hadoop/.ssh/authorized_keys
	cat $SETUP/hadoop/bashrc >> /home/hadoop/.bashrc

	cp /usr/local/lib/libhadoop.* /usr/share/hadoop/lib/native
	ln -s $JAVA_HOME/jre/lib/amd64/server/libjvm.so /usr/share/hadoop/lib/native/libjvm.so

	chown -Rf hadoop.hadoop hadoop

	cd /usr/share/hadoop/bin
	su - hadoop -c "hdfs namenode -format"
	cd ../..

	cp $SETUP/hadoop/init.d/hadoop /etc/init.d/hadoop
	chmod 755 /etc/init.d/hadoop

	service hadoop start
	
	$JAVA_HOME/bin/jps
	
	su - hadoop -c "/usr/share/hadoop/bin/hadoop fs -mkdir /user"

	cd $PPWD
fi