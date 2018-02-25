#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo -e "\nERROR: This script must be run as root\n" 1>&2
  exit 1
fi

# There is a .sh script for each app
AVAILABLE_APPS=( ant194 ads200 androidstudio301 cassandra39 cinnamon db60 db61 db62 dcevm django docker eclipse47 erlang groovy24 hadoop251 hbase112 httpd intellij34 java80 johntheripper180 lamp maven321 mysql nodejs622 openfire393 openldap24 openssl102 oracle11g2 play226 phppgadmin pgsql93 pgsql96 protobuf250 python276 ruby187 ruby226 sbt013 scala210 scala211 sdkman selenium242 solr610 spark152 tomcat80 tomcat85 vsftpd zookeeper346 )

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

function isinstalled {
  if yum list installed "$@" >/dev/null 2>&1; then
    true
  else
    false
  fi
}
