#!/bin/bash

# Secure FTP Server
yum install -y vsftpd
# Create server certificate for SFTP
echo -e "es\n\n\nTest Corp.\n\n\ntest@vagrant-guest.com\n" | openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /etc/vsftpd/vsftpd.pem -out /etc/vsftpd/vsftpd.pem
# Configure vsftpd
# Allow only root and tomcat users to SFTP
# Restrict tomcat user to his home directory
cp ./etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf
cp ./etc/vsftpd/ftpusers /etc/vsftpd/ftpusers
cp ./etc/vsftpd/user_list /etc/vsftpd/user_list
cp ./etc/vsftpd/chroot_list /etc/vsftpd/chroot_list
# Start vsftpd service on boot
chkconfig vsftpd on 35
