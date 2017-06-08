#!/bin/bash

# Add names from the .sh commands in the list to run them when setting up the machine for the first time
INSTALLED_APPS=( )

# AVAILABLE_APPS=( ant194 ads200 cassandra39 db61 dcevm java80 hbase112 hadoop251 lamp httpd maven321 openfire393 openldap24 play226 phppgadmin pgsql96 protobuf250 python276 sbt013 scala210 scala211 selenium242 solr610 tomcat80 tomcat85 tomcat-shared vsftpd zookeeper346 )

cd /vagrant/vagrant-setup
chmod a+x include.sh
source include.sh

# Set host name
cat ./etc/hosts >> /etc/hosts
HOST="centorion"
hostname $HOST
echo -e "NETWORKING=yes\nHOSTNAME=${HOST}" > /etc/sysconfig/network

# Enable the EPEL Repo
rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
# Use this one for CentOS 6.5
# rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

systemctl stop firewalld
systemctl mask firewalld
yum install -y iptables-services
iptables -A OUTPUT -p tcp --dport 25 -j REJECT
service iptables save
systemctl enable iptables
systemctl restart iptables

cd $SETUP

# Deny external SSH access to postgres, tomcat and play users
echo "DenyUsers postgres tomcat play" >> /etc/ssh/sshd_config

# No clear password authentication allowed
perl -pi -e "s/#?PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
perl -pi -e "s/#?PermitRootLogin yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
perl -pi -e "s/#?PermitEmptyPasswords yes/PasswordAuthentication no/g" /etc/ssh/sshd_config

# Keep yum packages in cache to speed up next vagrant destroy + vagrant up cycles
mkdir -p $SETUP/cache/yum
perl -pi -e "s/cachedir=\x2Fvar\x2Fcache\x2Fyum\x2F\x24basearch\x2F\x24releasever/cachedir=\x2Fvagrant\x2Fvagrant-setup\x2Fcache\x2Fyum\x2F\x24basearch\x2F\x24releasever/g" /etc/yum.conf
perl -pi -e "s/keepcache=0/keepcache=1/g" /etc/yum.conf

# PostgreSQL and Datastax Cassandra repositories
cp ./yum/*.repo /etc/yum.repos.d/

cp ./yum/RPM-GPG* /etc/pki/rpm-gpg/

# GCC, APR, OpenSSL Zip, Git and Mercurial stuff needed for compiling some source code later
yum install -y gcc gcc-c++ libtool make cmake bzip2 gzip lzo-devel zlib-devel wget apr-devel.x86_64 openssl-devel.x86_64 zip unzip git mercurial mercurial-hgk
# Add Git config
cp ./.ssh/config /home/vagrant/.ssh/
# Add Queues Extension to Mercurial
cp --remove-destination ./etc/mercurial/hgrc.d/hgk.rc /etc/mercurial/hgrc.d/

if [ -d "$SETUP/.m2" ]
	then
	cp -r $SETUP/.m2 /root
fi

cd $SETUP
for APP in "${AVAILABLE_APPS[@]}"
do
chmod a+x $APP.sh
done

for APP in "${INSTALLED_APPS[@]}"
do
source $APP.sh
cd $SETUP
done

cat /vagrant/vagrant-setup/.bashrc >> /home/vagrant/.bashrc

cd $SETUP