#!/bin/bash

if [ -d "/u01/app/oracle/middleware/wlserver" ]
	then

	echo "WebLogic is already installed, nothing done!"

else

	if [[ $EUID -eq 0 ]]
	then

		SETUP="/vagrant/vagrant-setup"
		PPWD=$PWD
		source $SETUP/include.sh

		if [ -d "/usr/share/weblogic" ]
		then
	
			echo "WebLogic is already installed, nothing done!"

		else
	
			if [ -f "$SETUP/cache/fmw_12.2.1.3.0_wls_Disk1_1of1.zip" ]
			then

				echo "Installing WebLogic 12.2.1.3..."

				[ -d "/u01" ] ; u01exists=$?

				echo "Creating permissions groups for WebLogic"
				if [ $(getent group oinstall) ]; then
					echo "Group oinstall already exists"
				else
					groupadd oinstall
				fi

				if getent passwd oracle > /dev/null 2>&1; then
					echo "User oracle already exists"
					if [ -f "/u01/oracle/.bashrc" ]
					then
						if grep -Gixq "^export WLS_HOME=.*$" /u01/oracle/.bashrc; then
							echo "/u01/oracle/.bashrc already contains WebLogic environment variables"
						else
							cat $SETUP/weblogic/bashrc >> /u01/oracle/.bashrc
						fi
					else
						if [ ! -d "/u01/oracle" ]
						then
							mkdir -p /u01/oracle
						fi
						cp $SETUP/oracle/bashrc /u01/oracle/.bashrc
						cat $SETUP/weblogic/bashrc >> /u01/oracle/.bashrc
					fi
				else
					if [ $(getent group oinstall) ]; then
						echo "Group oinstall already exists"
					else
						echo "Creating group oinstall"
						groupadd oinstall
					fi
					echo "Creating user oracle"
					mkdir -p /u01/oracle
					useradd -d /u01/oracle -K MAIL_DIR=/dev/null -g oinstall oracle
					chown -R oracle:oinstall /u01/oracle
					echo -e "0rclPasswd\n0rclPasswd\n" | passwd oracle
					cp $SETUP/oracle/bashrc /u01/oracle/.bashrc
					cat $SETUP/weblogic/bashrc >> /u01/oracle/.bashrc
				fi

				export MW_HOME=/u01/app/oracle/middleware
				export WLS_HOME=$MW_HOME/wlserver
				export WL_HOME=$WLS_HOME
				export ORACLE_HOME=/u01/app/oracle/product/12.2.0.1

				mkdir -p $MW_HOME
				mkdir -p /u01/software
				mkdir -p /u01/app/inventory
				mkdir -p /u01/app/oracle/config/domains
				mkdir -p /u01/app/oracle/config/applications

				if [ "$u01exists" = 1 ]
				then
					echo "Setting permissions of oracle user at /u01"
					chown -R oracle:oinstall /u01
					chmod -R 775 /u01/app
				fi

				yum -y install libaio bc flex net-tools

				cd /u01/software
				unzip $SETUP/cache/fmw_12.2.1.3.0_wls_Disk1_1of1.zip
				su oracle -c "java -Xmx1024m -jar fmw_12.2.1.3.0_wls.jar -silent -responseFile $SETUP/weblogic/wl_install.rsp -invPtrLoc $SETUP/oracle/oraInst.loc"
				rm fmw_12.2.1.3.0_wls.jar
				rm fmw_12213_readme.htm

				cd /u01/app/oracle/middleware/wlserver/server/bin
				. ./setWLSEnv.sh

				echo "Creating Weblogic domain 'wldomain' and starting Weblogic"
				cd /u01/app/oracle/config/domains
				mkdir wldomain
				chown -R oracle:oinstall wldomain
				chmod -R 775 wldomain
				cd wldomain
				su oracle -c "nohup java -Dweblogic.management.username=weblogic -Dweblogic.management.password=welcome01 -Dweblogic.Domain=wldomain -Dweblogic.Name=centorion -Dweblogic.ListenPort=7001 -Dweblogic.management.GenerateDefaultConfig=true weblogic.Server < /dev/null &> /dev/null &"

				# if [ -d "/usr/local/maven" ]
				# then
				# 	cd $MW_HOME/oracle_common/plugins/maven/com/oracle/maven/oracle-maven-sync/12.2.1
				# 	mvn install:install-file -DpomFile=oracle-maven-sync-12.2.1.pom -Dfile=oracle-maven-sync-12.2.1.jar
				# 	mvn com.oracle.maven:oracle-maven-sync:push -DoracleHome=/u01/app/oracle/middleware -Doracle-maven-sync.testingOnly=false
				# fi

			else

				echo "You must download https://download.oracle.com/otn/nt/middleware/12c/12213/fmw_12.2.1.3.0_wls_Disk1_1of1.zip and save it at /vagrant/vagrant-setup/cache before begining WebLogic 12 set up."

			fi
		fi

		cd $PPWD

	else

		echo "WebLogic must be installed as root. Type sudo ./weblogic12.sh for executing the script."

	fi
fi