#!/bin/bash

# Install Zookeeper 3.4.6

if [ -d "/usr/share/zookeeper" ]
	then

	echo "Zookeeper is already installed, nothing done!"

else

		SETUP="/vagrant/vagrant-setup"
		source $SETUP/include.sh

		PPWD=$PWD
		cd /usr/share

		ZOOKEEPER=zookeeper-3.4.6

		wget_and_untar http://apache.mirror.anlx.net/zookeeper/$ZOOKEEPER/ $ZOOKEEPER.tar.gz
		mv $ZOOKEEPER zookeeper
		cp $SETUP/zookeeper/zoo.cfg ./zookeeper/conf
		mkdir ./zookeeper/logs
		
		if getent passwd hadoop > /dev/null 2>&1; then
			echo "hadoop user already exists"
		else
			groupadd hadoop
			adduser hadoop -K MAIL_DIR=/dev/null -g hadoop
			# password login is disabled at /etc/ssh/sshd_config
			# echo -e "hadoop\nhadoop\n" | passwd hadoop
		fi
		chown -Rf hadoop.hadoop zookeeper
		su - hadoop -c "mkdir /home/hadoop/zookeeper"

		cp $SETUP/zookeeper/init.d/zookeeper /etc/init.d/zookeeper
		chmod 755 /etc/init.d/zookeeper

	  # Start Zookeeper at boot time
	  chkconfig --add zookeeper
	  chkconfig --level 234 zookeeper on
	  service zookeeper start

	cd $PPWD
fi