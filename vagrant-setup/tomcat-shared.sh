#!/bin/bash

# Install libraries needed by Clocial at Tomcat's shared loader

SLIB="/usr/share/tomcat/shared/lib"

if [ -d "/usr/share/tomcat" ]
	then

	source /vagrant/vagrant-setup/include.sh
	cd $SLIB
	# Copy Berkeley DB stub to shared loader folder
	if [ -f "/usr/share/db-6.1.19/build_unix/db.jar" ]
	then
	  cp /usr/share/db-6.1.19/build_unix/db.jar $SLIB
	fi

  # Add Scala runtime to shared loader folder
	if [ -f "/usr/share/scala/lib/scala-library.jar" ]
	then
    cp /usr/share/scala/lib/scala-library.jar $SLIB
    cp /usr/share/scala/lib/scala-actors-*.jar $SLIB
    cp /usr/share/scala/lib/scala-reflect.jar $SLIB
    cp /usr/share/scala/lib/akka-actor_*.jar $SLIB
	fi

  # Add HBase client to shared loader folder
	if [ -d "/usr/share/hbase/lib" ]
	then
    cp /usr/share/hbase/lib/hbase-common-*.jar $SLIB
    cp /usr/share/hbase/lib/hbase-client-*.jar $SLIB
    cp /usr/share/hbase/lib/hbase-protocol-*.jar $SLIB
    cp /usr/share/hbase/lib/hadoop-common-*.jar $SLIB
    cp /usr/share/hbase/lib/hadoop-client-*.jar $SLIB
    cp /usr/share/hbase/lib/zookeeper-*.jar $SLIB
  fi

	# Add some Apache Commons libraries to shared loader folder
	PROJECTS=( codec-1.9 configuration-1.10 discovery-0.5 fileupload-1.3.1 io-2.4 lang-2.6 lang3-3.3.2 logging-1.1.3 )
	for PROJ in "${PROJECTS[@]}"
	do
	  COMMON=commons-$PROJ
	  echo "Installing $COMMON"
	  if [ $PROJ == lang3-3.3.2 ]
	  then
	    SUBDIR=`echo lang`
	  else
	    SUBDIR=`echo $COMMON | cut -d'-' -f 2`
	  fi
	  echo "Subdir is $SUBDIR"
		wget_and_untar http://apache.mirror.anlx.net/commons/$SUBDIR/binaries/ $COMMON-bin.tar.gz
	  if [ $PROJ == fileupload-1.3.1 ]
	  then
	    cp ./$COMMON-bin/lib/$COMMON.jar $SLIB
	    rm -r -f $COMMON-bin
	  else
	    cp ./$COMMON/$COMMON.jar $SLIB
	    rm -r -f $COMMON
	  fi
	done

	LOG4J=apache-log4j-2.0.2-bin
  wget_and_untar http://www.mirrorservice.org/sites/ftp.apache.org/logging/log4j/2.0.2/ $LOG4J.tar.gz
  cp $LOG4J/log4j-core-2.0.2.jar $SLIB
  cp $LOG4J/log4j-1.2-api-2.0.2.jar $SLIB
  cp $LOG4J/log4j-api-2.0.2.jar $SLIB
	rm -r -f $LOG4J

	# Add SL4J to shared loader folder
	wget_and_untar http://www.slf4j.org/dist/ slf4j-1.7.7.tar.gz
	cp ./slf4j-1.7.7/slf4j-api-1.7.7.jar $SLIB
	cp ./slf4j-1.7.7/slf4j-log4j12-1.7.7.jar $SLIB
	rm -r -f slf4j-1.7.7

	# Add PostgreSQL and PostGIS JDBC drivers to shared loader folder
	if [ ! -f "postgresql-9.3-1101.jdbc4.jar" ]
	then
	  wget_and_cp http://jdbc.postgresql.org/download/ postgresql-9.3-1101.jdbc4.jar $SLIB
  fi
	if [ ! -f "postgis-jdbc-2.0.1.jar" ]
		then
	  wget_and_cp http://52north.org/maven/repo/releases/org/postgis/postgis-jdbc/2.0.1/ postgis-jdbc-2.0.1.jar $SLIB
	fi

	cd $PPWD

else

	echo "Tomcat not found, nothing done!"

fi