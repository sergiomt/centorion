#!/bin/bash

# Apache HTTPD
yum install -y httpd
chkconfig httpd on

# PHP
yum install -y php
