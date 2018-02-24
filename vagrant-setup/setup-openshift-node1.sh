#!/bin/bash

echo "Begin Openshift node provisioning"

INSTALLED_APPS=( java80 )

SETUP=/vagrant/vagrant-setup

cd $SETUP

# Set host name
cat ./etc/hosts >> /etc/hosts
HOST="openshift-node1"
hostname $HOST
echo -e "NETWORKING=yes\nHOSTNAME=${HOST}" > /etc/sysconfig/network

source openshift37.sh

echo "Openshift node provisioning done!"
