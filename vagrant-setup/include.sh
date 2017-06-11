#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo -e "\nERROR: This script must be run as root\n" 1>&2
  exit 1
fi

# There is a .sh script for each app
AVAILABLE_APPS=( ant194 ads200 cassandra39 db61 dcevm java80 hbase112 hadoop251 knowgate-src lamp httpd maven321 openfire393 openldap24 openssl102 play226 phppgadmin pgsql96 protobuf250 python276 ruby226 sbt013 scala210 scala211 selenium242 solr610 tomcat80 tomcat85 vsftpd zookeeper346 )

AVAILABLE_APPS=(${AVAILABLE_APPS[@]} clocial clocial-src clocial-test-db clocial-context clocial-db-create )

SETUP="/vagrant/vagrant-setup"
DOWNLOAD_PROXY=http://www.knowgate.com/shared/
PPWD=$PWD

JAVA_HOME=/usr/java/latest
export JAVA_HOME

if [ ! -d "$SETUP/cache" ]
	then
	mkdir -p $SETUP/cache
fi

wget_and_cp () {
	if [ ! -f "$SETUP/cache/$2" ]
		then
		wget $1$2 -O $SETUP/cache/$2
	fi
	if [ "$#" -eq 3 ]
		then
		cp $SETUP/cache/$2 $3
	fi
}

wget_and_untar () {
	if [ ! -f "$SETUP/cache/$2" ]
		then
		echo "downloading $2"
		wget $1$2 -O $SETUP/cache/$2
	fi
	if [ "$#" -eq 3 ]
		then
		mv $SETUP/cache/$2 $SETUP/cache/$3
		echo "untaring $3"
		tar -xzf $SETUP/cache/$3
		mv $SETUP/cache/$3 $SETUP/cache/$2
	else
		echo "untaring $2"
		tar -xzf $SETUP/cache/$2
	fi
}

wget_and_unzip () {
	if [ ! -f "$SETUP/cache/$2" ]
		then
		echo "downloading $2"
		wget $1$2 -O $SETUP/cache/$2
	fi
	if [ "$#" -eq 3 ]
		then
		mv $SETUP/cache/$2 $SETUP/cache/$3
		echo "unzipping $3"
		unzip $SETUP/cache/$3
		mv $SETUP/cache/$3 $SETUP/cache/$2
	else
		echo "unzipping $2"
		unzip $SETUP/cache/$2
	fi
}

wget_and_unbz2 () {
	if [ ! -f "$SETUP/cache/$2.bz2" ]
		then
		echo "downloading $1$2.bz2"
		wget $1$2.bz2 -O $SETUP/cache/$2.bz2
	fi
	if [ -f "$SETUP/cache/$2.bz2" ]
		then
		echo "$SETUP/cache/$2 already exists, skipped bzip2"
	else
		echo "decompressing and untaring $2.bz2"
		bzip2 -d $SETUP/cache/$2.bz2
	fi
	tar -xf $SETUP/cache/$2
}

wget_and_make_executable () {
	if [ ! -f "$SETUP/cache/$2" ]
		then
		wget $1$2 -O $SETUP/cache/$2
	fi
	chmod a+x $SETUP/cache/$2
}
