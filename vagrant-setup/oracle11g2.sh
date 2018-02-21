#!/bin/bash

if [[ $EUID -eq 0 ]]
then

	SETUP="/vagrant/vagrant-setup"
	PPWD=$PWD
	source $SETUP/include.sh

	PHYMX=$(free|awk '/^Mem:/{print $2}')
	SWAPS=`swapon -s`
	SWAPV=$(sed -n 2p <<< "$SWAPS")
	DEV1=$(echo $SWAPV | cut -d ' ' -f 1)
	SWAPX=$(echo $SWAPV | cut -d ' ' -f 3)
	echo "Swap Size is ${SWAPX}Kb"
	echo "Physical Memory is ${PHYMX}Kb"

	if [ -f "$SETUP/cache/oracle-xe-11.2.0-1.0.x86_64.rpm.zip" ]
	then

		yum -y install libaio bc flex net-tools
		unzip $SETUP/cache/oracle-xe-11.2.0-1.0.x86_64.rpm.zip
		rpm -ivh Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm
		chmod -R ugo+w Disk1
		rm -r Disk1
		/etc/init.d/oracle-xe configure

	else

	echo "You must download http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip and save it at /vagrant/vagrant-setup/cache before begining Oracle XE set up."

	fi

else

	echo "Oracle must be installed as root. Type sudo ./oracle11g2.sh for executing the script."

fi