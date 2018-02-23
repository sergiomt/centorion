#!/bin/bash

echo "Begin Openshift master provisioning"

SETUP=/vagrant/vagrant-setup

cd $SETUP

# Set host name
cat ./etc/hosts >> /etc/hosts
HOST="openshift-master"
hostname $HOST
echo -e "NETWORKING=yes\nHOSTNAME=${HOST}" > /etc/sysconfig/network

source openshift37.sh

cd /usr/local
[ ! -d openshift ] && git clone https://github.com/openshift/openshift-ansible.git
mv openshift-ansible openshift
cd openshift
git fetch
git checkout release-3.7

cp $SETUP/openshift/config.yml ./playbooks/byo/

echo "Openshift master provisioning done!"
