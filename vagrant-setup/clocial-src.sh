#!/bin/bash

# You need to have an SSH key with name id_dsa at /vagrant/vagrant-setup/.ssh or ~/.ssh
# This script will copy id_dsa to ~/.ssh
# This SSH key must be already authorized to clone and push to Clocial repositories

SETUP="/vagrant/vagrant-setup"
MAVEN="/usr/local/maven"
KEYS=( id_dsa id_rsa )

export M2_HOME=$MAVEN
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

if [[ $EUID -eq 0 ]]
  then
	VSSH="/root/.ssh"
else
	VSSH="/home/$USER/.ssh"
fi

echo $VSSH

# Install SSH keys for Git
if [ -a "$SETUP/.ssh/config" ]
then
	if [ ! -a "$VSSH/config" ]
	then
		mkdir -p --mode=700 $VSSH
		rsync $SETUP/.ssh/config $VSSH/config
	  chmod 600 $VSSH/config
	fi
fi
eval `ssh-agent`
for KEY in "${KEYS[@]}"
do
	if [ -a "$SETUP/.ssh/$KEY" ]
	then
		if [ ! -a "$VSSH/$KEY" ]
		then
  	  rsync $SETUP/.ssh/$KEY $VSSH/$KEY
			chmod 600 $VSSH/$KEY
  		ssh-add $VSSH/$KEY
  	fi
  fi
done

if [ -a "$VSSH/id_dsa" -o -a "$VSSH/id_rsa" ]
then

	source $SETUP/knowgate-src.sh

	# Download and compile source code

	if [ -d "/vagrant/workspace/clocial" ]
	then
		echo "/vagrant/workspace/clocial already exists, skipping git clone for this repository"
  else
	  cd /vagrant/workspace
	  git clone https://github.com/sergiomt/clocial.git
	fi

	if [ -d "$MAVEN" ]
	then
	  cd /vagrant/workspace/clocial/clocial-pojo
		mvn install -DskipTests
		cd ../clocial-scala
		mvn install -DskipTests
		cd ../clocial-web
		mvn compile
		mvn package
		
    if [ -d "/usr/share/tomcat" ]
    then
			# Create a symbolic link from Tomcat webapps to Maven target
			# This is an alternative to creating a context with docBase=/vagrant/clocial/clocial-web/target/clocial-web-1.0
			# if [ ! -h "/user/share/tomcat/webapps/clocial" ]
			# then
			#		ln -s /vagrant/clocial/clocial-web/target/clocial-web-1.0 /usr/share/tomcat/webapps/clocial
			# fi
			# Create context for clocial webapp
			mkdir -p /usr/share/tomcat/conf/Catalina/localhost
			cp $SETUP/clocial/conf/Catalina/localhost/clocial.xml /usr/share/tomcat/conf/Catalina/localhost
			# Copy webapp configuration files
			# cp -r -f $SETUP/clocial/webapps/conf/WEB-INF/* /usr/share/tomcat/webapps/clocial/WEB-INF
			cp -r -f $SETUP/clocial/webapps/conf/WEB-INF/* /vagrant/clocial/clocial-web/target/clocial-web-1.0/WEB-INF
		fi

		# Check that all the .jar files have been generated

		if [ -f "/vagrant/workspace/clocial/clocial-pojo/target/clocial-pojo-1.0.jar" ]
		then
			echo "Clocial POJO libraries successfully compiled and installed at Maven"
		else
			echo "ERROR: Failed to compile or install Clocial POJO libraries"
		fi
		if [ -f "/vagrant/workspace/clocial/clocial-scala/target/clocial-scala-1.0.jar" ]
		then
			echo "Clocial Scala libraries successfully compiled and installed at Maven"
		else
			echo "ERROR: Failed to compile or install Clocial Scala libraries"
		fi
	fi

else
	echo "A private key authorized on Git repositories is required. Put your id_dsa or id_rsa SSH key at $SETUP/.ssh and re-run this script."	
fi