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

	if [ -f "$SETUP/cache/linuxx64_12201_database.zip" ]
	then
		yum install -y binutils.x86_64 compat-libcap1.x86_64 gcc.x86_64 gcc-c++.x86_64 glibc.i686 glibc.x86_64 glibc-devel.i686 glibc-devel.x86_64 ksh compat-libstdc++-33 libaio.i686 libaio.x86_64 libaio-devel.i686 libaio-devel.x86_64 libgcc.i686 libgcc.x86_64 libstdc++.i686 libstdc++.x86_64 libstdc++-devel.i686 libstdc++-devel.x86_64 libXi.i686 libXi.x86_64 libXtst.i686 libXtst.x86_64 make.x86_64 sysstat.x86_64

		if getent passwd oracle > /dev/null 2>&1; then
			echo "oracle user already exists"
		else
			echo "Creating user oracle"
			groupadd oinstall
			groupadd dba
			groupadd oper
			useradd -d /u01 -K MAIL_DIR=/dev/null -g oinstall oracle
			usermod -a -G dba oracle
			usermod -a -G oper oracle
			echo -e "0rclPasswd\n0rclPasswd\n" | passwd oracle
			cat $SETUP/oracle/bashrc >> /u01/.bashrc
		fi

		mkdir -p /u01/app/oracle/middleware
		mkdir -p /u01/app/oracle/config/domains
		mkdir -p /u01/app/oracle/config/applications
		mkdir -p /u01/app/oracle/product/12.2.0.1/network/log/
		mkdir -p /var/lib/oracle/12.2.0.1/data
		mkdir -p /var/lib/oracle/12.2.0.1/recovery

		chown -R oracle:oinstall /var/lib/oracle
		chmod -R 775 /var/lib/oracle

		cd /u01/app/oracle/
		unzip $SETUP/cache/linuxx64_12201_database.zip

		chown -R oracle:oinstall /u01
		chmod -R 775 /u01/

		cd database
		su oracle -c "./runInstaller -ignorePrereq -silent -responseFile $SETUP/oracle/12.2.0.1/database/db_install.rsp"

		export ORACLE_HOME=/u01/app/oracle/product/12.2.0.1
		export ORACLE_SID=SE2
		export ORACLE_BASE=/var/lib/oracle/12.2.0.1

		cd /u01/app/inventory/
		./orainstRoot.sh
		cd /u01/app/oracle/product/12.2.0.1
		./root.sh

		cd bin
		su oracle -c "./dbca -silent -createDatabase -responseFile $SETUP/oracle/12.2.0.1/database/dbca.rsp"

		if [[ ! $(iptables -nL | grep "dpt:1521") ]]
		then
			iptables -A INPUT -p tcp --dport 1521 -j ACCEPT
			service iptables save
			systemctl restart iptables
		fi

		cp $SETUP/oracle/12.2.0.1/database/listener.ora $ORACLE_HOME/network/admin
		su oracle -c "./lsnrctl start"

	else
	
	echo "You must download linuxx64_12201_database.zip and save it at /vagrant/vagrant-setup/cache before begining Oracle 12c set up."

	fi

else

	echo "Oracle must be installed as root. Type sudo ./oracle11g2.sh for executing the script."

fi