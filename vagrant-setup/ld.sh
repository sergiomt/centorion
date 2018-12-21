#!/bin/bash

if ! grep -q "/usr/local/lib64" "/etc/ld.so.conf"; then
	echo -e "/usr/local/lib64" >> /etc/ld.so.conf
	ldconfig
else
	echo "Nothing done"
fi
		
