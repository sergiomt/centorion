#!/bin/bash

# Install Berkeley DB 6.1
# http://www.linuxfromscratch.org/blfs/view/cvs/server/db.html
# http://docs.oracle.com/cd/E17275_01/html/programmer_reference/build_unix_conf.html

if [ -d "/usr/share/db-6.1.19" ]
	then

	echo "Berkeley DB 6.1 is already installed, nothing done!"

else

	source /vagrant/vagrant-setup/include.sh

	# Berkeley DB 6.1 Can't compile the Java bindings with Java 8
	# so install Java 7, compile and uninstall Java 7
	yum install -y java-1.7.0-openjdk-devel

	cd /usr/share
	wget_and_untar http://download.oracle.com/berkeley-db/ db-6.1.19.tar.gz
	cd db-6.1.19
	rm -f -r build_wince
	rm -f -r build_windows
	rm -f -r build_vxworks
	cd build_unix
	../dist/configure --prefix=/usr --enable-java --enable-cxx && make
	
	# OpenLDAP will look for libdb.so library
	# If this is omitted then "Berkeley DB link (-ldb) no" error is raised when building OpenLDAP
	# http://doc.gnu-darwin.org/build_unix/shlib.html
	cd .libs
	ln -s libdb-6.1.so libdb.so

	cd $PPWD

	yum erase -y java-1.7.0-openjdk-devel
	unlink /usr/lib/jvm/jre-1.7.0-openjdk.x86_64
	unlink /usr/lib/jvm/jre-openjdk
	unlink /etc/alternatives/java
	unlink /etc/alternatives/java.1.gz
	unlink /etc/alternatives/jre_1.7.0
	unlink /etc/alternatives/jre_1.7.0_exports
	unlink /etc/alternatives/jre_openjdk
	unlink /etc/alternatives/jre_openjdk_exports
	unlink /etc/alternatives/keytool
	unlink /etc/alternatives/keytool.1.gz
	unlink /etc/alternatives/rmid
	unlink /etc/alternatives/rmid.1.gz
	unlink /etc/alternatives/rmiregistry
	unlink /etc/alternatives/rmiregistry.1.gz
	unlink /etc/alternatives/servertool
	unlink /etc/alternatives/servertool.1.gz
	unlink /etc/alternatives/tnameserv
	unlink /etc/alternatives/tnameserv.1.gz
	unlink /etc/alternatives/unpack200
	unlink /etc/alternatives/unpack200.1.gz
	rm -rf /usr/lib/jvm/jre-1.7.0
	rm -rf /usr/lib/java-1.7.0-openjdk-1.7.0.91.x86_64
	rm -rf /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.91.x86_64
 
fi