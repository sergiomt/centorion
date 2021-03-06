#!/bin/bash

echo "Begin machine provisioning"

# Add names from the .sh commands in the list to run them when setting up the machine for the first time
INSTALLED_APPS=( )

# Add the desired of these applications to the list above
# Applications will be installed in order of appearance,
# so do not put them in alphabetical order.
# AVAILABLE_APPS=( ant194 ads200 androidstudio301 cassandra39 cinnamon db60 db61 db62 dcevm django docker eclipse48 editix elasticsearch6 erlang groovy24 hadoop251 hbase112 httpd intellij34 java80 johntheripper180 kibana6 kotlin lamp maven353 mysql nagios411 nodejs622 openfire393 openldap24 openssl102 openssl110 oracle11g2 oracle12c play226 phppgadmin pgsql93 pgsql96 protobuf250 python276 ruby187 ruby226 sbt013 scala210 scala211 scala212 sdkman selenium242 solr610 spark152 tomcat80 tomcat85 vsftpd weblogic12 zookeeper346 )

cd /vagrant/vagrant-setup
chmod a+x include.sh
source include.sh

# Set host name
cat ./etc/hosts >> /etc/hosts
HOST="centorion"
hostname $HOST
echo -e "NETWORKING=yes\nHOSTNAME=${HOST}" > /etc/sysconfig/network

echo "Enabling EPEL Repo"
rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm

systemctl stop firewalld
systemctl mask firewalld
yum install -y iptables-services
iptables -A OUTPUT -p tcp --dport 25 -j REJECT
service iptables save
systemctl enable iptables
systemctl restart iptables

cd $SETUP

# Deny external SSH access to postgres, tomcat, play and clocial users
echo "DenyUsers postgres tomcat play clocial oracle" >> /etc/ssh/sshd_config

# No clear password authentication allowed
perl -pi -e "s/#?PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
perl -pi -e "s/#?PermitRootLogin yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
perl -pi -e "s/#?PermitEmptyPasswords yes/PasswordAuthentication no/g" /etc/ssh/sshd_config

# Keep yum packages in cache to speed up next vagrant destroy + vagrant up cycles
mkdir -p $SETUP/cache/yum
perl -pi -e "s/cachedir=\x2Fvar\x2Fcache\x2Fyum\x2F\x24basearch\x2F\x24releasever/cachedir=\x2Fvagrant\x2Fvagrant-setup\x2Fcache\x2Fyum\x2F\x24basearch\x2F\x24releasever/g" /etc/yum.conf
perl -pi -e "s/keepcache=0/keepcache=1/g" /etc/yum.conf

# Datastax Cassandra repositories
cp ./yum/*.repo /etc/yum.repos.d/

cp ./yum/RPM-GPG* /etc/pki/rpm-gpg/

echo "Installing GCC, APR, ZIP"
# GCC, APR, Git and Mercurial stuff needed for compiling some source code later
yum install -y gcc gcc-c++ libtool make cmake bzip2 gzip lzo-devel zlib-devel wget zip unzip

echo "Installing OpenSSL 1.0.2"
yum remove -y openssl
source $SETUP/openssl102.sh
cp --remove-destination /usr/local/ssl/bin/openssl /usr/bin/openssl

echo "Installing Git and Mercurial"
yum install -y apr-devel.x86_64 git mercurial mercurial-hgk
# Add Git config
cp $SETUP/.ssh/config /home/vagrant/.ssh/
chown vagrant:vagrant /home/vagrant/.ssh/config
chmod 600 /home/vagrant/.ssh/config
# Add Queues Extension to Mercurial
cp --remove-destination $SETUP/etc/mercurial/hgrc.d/hgk.rc /etc/mercurial/hgrc.d/
cp --remove-destination $SETUP/mercurial/.hgrc /root
cp --remove-destination $SETUP/mercurial/.hgrc /home/vagrant
chown vagrant:vagrant /home/vagrant/.hgrc

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

echo "Machine provisioning done!"
