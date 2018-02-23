#!/bin/bash

SETUP=/vagrant/vagrant-setup

ssh -o StrictHostKeyChecking=no root@192.168.101.111 "pwd" < /dev/null
ssh -o StrictHostKeyChecking=no root@192.168.101.112 "pwd" < /dev/null

ansible-playbook -i $SETUP/openshift/inventory.ini /usr/local/openshift/playbooks/byo/config.yml

# htpasswd -b /etc/origin/master/htpasswd root vagrant
# oc adm policy add-cluster-role-to-user cluster-admin root

# systemctl restart origin-master-api

# oc login -u ${USERNAME} -p ${PASSWORD} https://console.$DOMAIN:8443/

