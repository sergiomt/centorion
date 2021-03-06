#!/bin/bash

HTTPD=`which httpd`
if [[ $HTTPD == "*no httpd*" ]]
	then

	echo "HTTPD is already installed. Nothing Done!"

else

	# Apache HTTPD
	yum install -y httpd
	perl -pi -e "s/\s*#?\s*ServerName\s+.+/ServerName localhost:80\\1/g" /etc/httpd/conf/httpd.conf
	systemctl enable httpd.service
	systemctl start httpd.service

	# PHP
	yum install -y php

fi