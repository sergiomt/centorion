#!/bin/bash

PPWD=$PWD

SETUP="/vagrant/vagrant-setup"

source $SETUP/include.sh

cd /usr/local/src
wget_and_untar https://www.openssl.org/source/ openssl-1.1.0i.tar.gz
cd openssl-1.1.0i
./config --prefix=/usr --openssldir=/usr
make && make install

cp --remove-destination /usr/local/src/openssl-1.1.0i/include/openssl/*.h /usr/local/include/openssl

if ! grep -q "/usr/local/lib64" "/etc/ld.so.conf"; then
	echo -e "/usr/local/lib64" >> /etc/ld.so.conf
	ldconfig
fi

rm -f /usr/bin/openssl
rm -f /usr/local/bin/openssl

ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/bin/openssl /usr/local/bin/openssl

cd $PWD