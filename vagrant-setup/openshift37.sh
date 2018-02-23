#!/bin/bash

SETUP=/vagrant/vagrant-setup
PPWD=$PWD

cd $SETUP
chmod a+x include.sh
source include.sh

echo "Enabling EPEL Repo"
yum -y install epel-release

systemctl stop firewalld
systemctl mask firewalld
yum install -y iptables-services
iptables -A OUTPUT -p tcp --dport 25 -j REJECT
service iptables save
systemctl enable iptables
systemctl restart iptables

# Keep yum packages in cache to speed up next vagrant destroy + vagrant up cycles
mkdir -p $SETUP/cache/yum
perl -pi -e "s/cachedir=\x2Fvar\x2Fcache\x2Fyum\x2F\x24basearch\x2F\x24releasever/cachedir=\x2Fvagrant\x2Fvagrant-setup\x2Fcache\x2Fyum\x2F\x24basearch\x2F\x24releasever/g" /etc/yum.conf
perl -pi -e "s/keepcache=0/keepcache=1/g" /etc/yum.conf

# PostgreSQL and Datastax Cassandra repositories
cp ./yum/*.repo /etc/yum.repos.d/

cp ./yum/RPM-GPG* /etc/pki/rpm-gpg/

yum install -y gcc gcc-c++ libtool make cmake \
bzip2 gzip lzo-devel zlib-devel wget zip unzip \
ansible zile nano net-tools docker openssl-devel \
python-cryptography pyOpenSSL.x86_64 python2-pip python-devel python-passlib \
httpd-tools NetworkManager

systemctl | grep "NetworkManager.*running" 
if [ $? -eq 1 ]; then
	systemctl start NetworkManager
	systemctl enable NetworkManager
fi

which ansible || pip install -Iv ansible

echo "Installing APR, Git and Mercurial"
yum install -y apr-devel.x86_64 git mercurial mercurial-hgk

# Add Queues Extension to Mercurial
cp --remove-destination $SETUP/etc/mercurial/hgrc.d/hgk.rc /etc/mercurial/hgrc.d/

if [ -z $DISK ]; then 
	echo "Not setting the Docker storage."
else
	cp /etc/sysconfig/docker-storage-setup /etc/sysconfig/docker-storage-setup.bk

	echo DEVS=$DISK > /etc/sysconfig/docker-storage-setup
	echo VG=DOCKER >> /etc/sysconfig/docker-storage-setup
	echo SETUP_LVM_THIN_POOL=yes >> /etc/sysconfig/docker-storage-setup
	echo DATA_SIZE="100%FREE" >> /etc/sysconfig/docker-storage-setup

	systemctl stop docker

	rm -rf /var/lib/docker
	wipefs --all $DISK
	docker-storage-setup
fi

systemctl restart docker
systemctl enable docker

mkdir -p ~/.ssh
if [ ! -f ~/.ssh/id_rsa ]; then
	if [ -f $SETUP/openshift/id_rsa ]; then
		cp $SETUP/openshift/id_rsa ~/.ssh
		cp $SETUP/openshift/id_rsa.pub ~/.ssh
	else
		ssh-keygen -q -f ~/.ssh/id_rsa -N ""
	fi
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/id_rsa
	chmod 600 ~/.ssh/id_rsa.pub
	chmod 600 ~/.ssh/authorized_keys
fi

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
cat /vagrant/vagrant-setup/.bashrc >> /root/.bashrc

cd $PPWD
