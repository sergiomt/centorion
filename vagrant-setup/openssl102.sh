#!/bin/bash

PPWD=$PWD

SETUP="/vagrant/vagrant-setup"

source $SETUP/include.sh

cd /usr/local/src
wget_and_untar https://www.openssl.org/source/ openssl-1.0.2-latest.tar.gz
cd openssl-1.0.2n
./config
make
make install

rm /usr/bin/openssl

ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl

cd $PWD