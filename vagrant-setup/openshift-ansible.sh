#!/bin/bash

SETUP=/vagrant/vagrant-setup

ssh -o StrictHostKeyChecking=no root@192.168.101.111 "pwd" < /dev/null
ssh -o StrictHostKeyChecking=no root@192.168.101.112 "pwd" < /dev/null

ansible-playbook -i $SETUP/openshift/inventory.ini /usr/local/openshift/playbooks/byo/config.yml

htpasswd -b /etc/origin/master/htpasswd admin admin

oc adm policy add-cluster-role-to-user cluster-admin admin

systemctl restart origin-master-api

oc login -u admin -p admin https://192.168.101.111:8443/

