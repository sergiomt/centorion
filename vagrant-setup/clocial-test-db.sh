#!/bin/bash

JAVA_HOME=/usr/java/latest
SHARE=/usr/share
SHARED=$SHARE/tomcat/shared/lib
M2REPO=/home/vagrant/.m2/repository
WORKSPACE=/vagrant/workspace
WEBINF=$WORKSPACE/clocial/clocial-web/target/clocial-web-1.0/WEB-INF/lib
TARGET=$WORKSPACE/clocial/clocial-devel/target
FATJAR=$WORKSPACE/clocial/clocial-web/target/clocial-webapp-jar-with-dependencies.jar
DEVEL=$WORKSPACE/clocial/clocial-devel/target/clocial-devel-1.0.jar
BDBBUCKET=/opt/bdb/bucket

# sudo $JAVA_HOME/bin/java -cp $FATJAR:$SHARED/*:$WEBINF/* com.knowgate.debug.DebugFile

# Uncomment to run Berkeley DB db_recover
# if [ -d "$BDBBUCKET" ]
# then
#  	echo Running Berkeley DB Recover
#  	$SHARE/db-6.2.32/build_unix/db_recover -v -h $BDBBUCKET
# else
#  	echo Creating directory $BDBBUCKET
# 	mkdir -p $BDBBUCKET 
# fi

# Uncomment this line for deleting all images from test bucket
# echo Deleting images from test bucket
# sudo $JAVA_HOME/bin/java -cp $FATJAR:$SHARED/*:$WEBINF/*:$M2REPO/junit/junit/4.11/junit-4.11.jar:$TARGET/test-classes -Djava.library.path=/usr/share/db-6.2.32/build_unix/.libs com.clocial.test.Blobs truncate

# Uncomment this line for deleting all tables and functions at the database before re-creating it
echo Droping datamodel
sudo $JAVA_HOME/bin/java -cp $DEVEL:$FATJAR:$SHARED/*:$WEBINF/* com.clocial.datamodel.ClocialDataModelManager /etc/clocial.cnf drop database

# Create Clocial datamodel
echo Creating datamodel
sudo $JAVA_HOME/bin/java -cp $DEVEL:$FATJAR:$SHARED/*:$WEBINF/* com.clocial.datamodel.ClocialDataModelManager /etc/clocial.cnf create database

# Populate the database specified at $TARGET/test-classes/com/clocial/test/testrdbms.cnf with test data
# echo Populating database with test data
# sudo $JAVA_HOME/bin/java -cp $DEVEL:$FATJAR:$SHARED/*:$WEBINF/*:$M2REPO/junit/junit/4.11/junit-4.11.jar:$TARGET/test-classes -Djava.library.path=/usr/share/db-6.2.32/build_unix/.libs com.clocial.users.UsersCreation

# Uncomment to create HBase tables for InMailService
# if [ -d "/usr/share/hbase/conf" ]
# then
# sudo $JAVA_HOME/bin/java -cp $DEVEL:$FATJAR:$TARGET/classes/:$SHARED/:$WEBINF/* com.clocial.inmail.InMailService create /usr/share/hbase/conf/
# fi
