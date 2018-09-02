#!/bin/bash

PPWD=$PWD
JAVA_HOME=/usr/java/latest
SHARE=/usr/share
SHARED=$SHARE/tomcat/shared/lib
M2REPO=/home/vagrant/.m2/repository
WORKSPACE=/vagrant/workspace
WEBINF=$WORKSPACE/clocial/clocial-web/target/clocial-web-1.0/WEB-INF/lib
TARGET=$WORKSPACE/clocial/clocial-devel/target
SERVICES=$WORKSPACE/clocial/clocial-service/target/clocial-services-1.0.jar
DEVEL=$WORKSPACE/clocial/clocial-devel/target/clocial-devel-1.0.jar
BDBBUCKET=/opt/bdb/bucket

if [ -d "/usr/local/clocial" ]
	then
	echo Deleting images from test bucket
	cd $WORKSPACE/clocial/clocial-devel
	mvn exec:java -P blobs -Dexec.args="truncate"
	cd $PPWD
else
	sudo mkdir /usr/local/clocial
	sudo chown -R vagrant.vagrant /usr/local/clocial
	sudo chmod 766 /usr/local/clocial
fi

# Uncomment to run Berkeley DB db_recover
# if [ -d "$BDBBUCKET" ]
# then
#  	echo Running Berkeley DB Recover
#  	$SHARE/db-6.2.32/build_unix/db_recover -v -h $BDBBUCKET
# else
#  	echo Creating directory $BDBBUCKET
# 	mkdir -p $BDBBUCKET 
# fi

# Uncomment this line for deleting all tables and functions at the database before re-creating it
echo Droping datamodel
cd $WORKSPACE/clocial/clocial-devel
mvn exec:java -P database -Dexec.args="/etc/clocial.cnf drop database"
cd $PPWD

# Create Clocial datamodel
echo Creating datamodel
cd $WORKSPACE/clocial/clocial-devel
mvn exec:java -P database -Dexec.args="/etc/clocial.cnf create database"
cd $PPWD

# Populate the database specified at $TARGET/test-classes/com/clocial/test/testrdbms.cnf with test data
echo Populating database with test data
mkdir -p /opt/lucene/clocialdev/k_user_avatars
cd $WORKSPACE/clocial/clocial-devel
mvn -Dtest=UsersCreation test
cd $PPWD

# Uncomment to create HBase tables for InMailService
if [ -d "/usr/share/hbase/conf" ]
then
	cd $WORKSPACE/clocial/clocial-devel
	mvn exec:java -P inmail -Dexec.args="create $TARGET/test-classes/com/clocial/users/testhbase.cnf"
	cd $PPWD
fi
