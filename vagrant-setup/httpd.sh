#!/bin/bash

# Apache HTTPD
yum install -y httpd
perl -pi -e "s/\s*#?\s*ServerName\s+.+/ServerName localhost:80\\1/g" $PHPCONF
systemctl enable httpd.service
systemctl start httpd.service

# PHP
yum install -y php
