#!/bin/bash

PPWD=$PWD

SETUP="/vagrant/vagrant-setup"

source $SETUP/include.sh

cd /usr/local/src
wget_and_untar https://www.openssl.org/source/ openssl-1.0.2p.tar.gz
cd openssl-1.0.2p
./config shared --openssldir=/usr/local/ssl -fPIC -Wl,-rpath=/usr/local/ssl/lib
make
make test
make install

if ! grep -q "/usr/local/ssl/lib" "/etc/ld.so.conf"; then
	echo -e "/usr/local/ssl/lib" >> /etc/ld.so.conf
	ldconfig
fi

rm -f /usr/bin/openssl
rm -f /usr/local/bin/openssl

ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/bin/openssl /usr/local/bin/openssl


cd $PWD