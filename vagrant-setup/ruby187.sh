#!/bin/bash

SETUP="/vagrant/vagrant-setup"
source $SETUP/include.sh

yum install -y automake autoconf curl-devel httpd-devel apr-util-devel sqlite-devel
yum install -y ruby-1.8.7.374-4.el6_6.x86_64
yum install -y ruby-rdoc-1.8.7.374-4.el6_6.x86_64 ruby-devel-1.8.7.374-4.el6_6.x86_64
yum install -y rubygems-1.3.7-5.el6.noarch
