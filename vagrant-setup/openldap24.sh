#!/bin/bash

# Install Open LDAP 2.4.39
# http://www.openldap.org/doc/admin24/install.html
# http://www.zytrax.com/books/ldap/
# http://books.google.co.uk/books?id=Lt68W9QkQ6sC

rm -r -f /usr/share/openldap

if [ -d "/usr/share/openldap" ]
	then

	echo "OpenLDAP 2.4.39 is already installed, nothing done!"

else

	BDB=db-6.2.32
	if [ -d "/usr/share/$BDB" ]
		then

			if [[ $EUID -eq 0 ]]
		  then
			source /vagrant/vagrant-setup/include.sh
			yum install -y gnutls tcp_wrappers-devel cyrus-sasl-devel
			if grep -q "slapd: ALL" /etc/hosts.allow
			then
				echo "slapd already present in /etc/hosts.allow"
			else
				echo -e "\nsshd: ALL\nslapd: ALL\nslurpd: ALL" >> /etc/hosts.allow
			fi
			cd /usr/share
			wget_and_untar ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/ openldap-2.4.39.tgz
			mv openldap-2.4.39 openldap
			cd openldap
			export CFLAGS="-I/usr/share/$BDB/build_unix"
			export CPPFLAGS="-D_REENTRANT -I/usr/share/$BDB/build_unix"
			export LDFLAGS="-L/usr/share/$BDB/build_unix/.libs"
			export LD_LIBRARY_PATH="/usr/share/$BDB/build_unix/.libs"

			# ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libexecdir=/usr/lib --disable-static --disable-debug --with-tls=openssl --with-cyrus-sasl --enable-dynamic --enable-crypt --enable-spasswd  --enable-slapd --enable-modules --enable-rlookups --enable-backends=mod --disable-ndb --disable-sql --disable-shell --disable-bdb --disable-hdb --enable-overlays=mod
			./configure --enable-wrappers --enable-ppolicy --enable-mdb --disable-bdb --disable-hdb --disable-sql
			make depend
			make
			make install

			mkdir -p /usr/local/etc/openldap/slapd.d
			mkdir -p /usr/local/var/auth-data/logs

			# Create slapd.ldif file for auth.com
			rm -f /usr/local/var/auth-data/DB_CONFIG
			echo -e "# http://docs.oracle.com/cd/E17076_04/html/api_reference/C/configuration_reference.html\n# http://sepp.oetiker.ch/subversion-1.4.6-rp/ref/toc.html\n\n# Cache 5Mb\nset_cachesize 0 5242880 1\n\n# Transaction Log settings\nset_lg_regionmax 262144\nset_lg_bsize 2097152\nset_lk_detect DB_LOCK_DEFAULT\nset_flags DB_TXN_NOSYNC\nset_lg_dir logs" > /usr/local/var/auth-data/DB_CONFIG
			cp $SETUP/ldap/slapd2.ldif /usr/local/etc/openldap/slapd.ldif
			/usr/local/sbin/slapadd -d -1 -F /usr/local/etc/openldap/slapd.d -n 0 -l /usr/local/etc/openldap/slapd.ldif
			/usr/local/sbin/slapadd -d -1 -F /usr/local/etc/openldap/slapd.d -n 0 -l /usr/local/etc/openldap/schema/cosine.ldif
			/usr/local/sbin/slapadd -d -1 -F /usr/local/etc/openldap/slapd.d -n 0 -l /usr/local/etc/openldap/schema/inetorgperson.ldif

			# Create /etc/init.d/slapd [start|stop|restart]
			cp $SETUP/ldap/init.d/slapd /etc/init.d/slapd
			chmod 755 /etc/init.d/slapd
			# Start slapd at boot
			chkconfig --level 234 slapd on

			# Install PHP LDAP Admin
			HTTPD=`which httpd`
			if [[ $HTTPD == "*no httpd*" ]]
				then
				echo "No httpd service found, skipping phpldapadmin setup"
			else
				if isinstalled phpldapadmin
					then
					echo "PHP LDAP Admin is already installed."
				else
					yum install -y phpldapadmin
					perl -pi -e "s/(\x2F\x2F)?\s*\x24servers->setValue\x28'login','base',array\x28\x29\x29/\x24servers->setValue\x28'login','base',array\x28'dc=auth,dc=com'\x29\x29/g" /etc/phpldapadmin/config.php
					perl -pi -e "s/(\x2F\x2F)?\s*\x24servers->setValue\x28'login','bind_id',''\x29/\x24servers->setValue\x28'login','bind_id','cn=Manager,dc=auth,dc=com'\x29/g" /etc/phpldapadmin/config.php
					perl -pi -e "s/(\x2F\x2F)?\s*\x24servers->setValue\x28'login','attr','uid'\x29/\x24servers->setValue\x28'login','attr','dn'\x29/g" /etc/phpldapadmin/config.php
					perl -pi -e "s/\x2F\x2F\s+\x24config->custom->appearance\x5B'hide_template_warning'\x5D = false/\x24config->custom->appearance\x5B'hide_template_warning'\x5D = true/g" /etc/phpldapadmin/config.php
					perl -pi -e "s/Allow from 127\x2E0\x2E0\x2E1/Allow from all/g" /etc/httpd/conf.d/phpldapadmin.conf
					perl -pi -e "s/Require local/Require all granted/g" /etc/httpd/conf.d/phpldapadmin.conf
					systemctl restart httpd.service
				fi
			fi

			if [[ ! $(iptables -nL | grep "dpt:389") ]]
			then
				iptables -A INPUT -p tcp --dport 389 -j ACCEPT
				service iptables save
				systemctl restart iptables
			fi

			/etc/init.d/slapd start

			echo "Loading Root LDAP entry..."
			/usr/local/bin/ldapadd -x -w secret -D "cn=Manager,dc=auth,dc=com" -f /vagrant/vagrant-setup/ldap/auth.ldif

			echo "Adding password policy overlay"
			/usr/local/bin/ldapadd -w secret -D "cn=root,cn=config" -f /vagrant/vagrant-setup/ldap/ppolicyoverlay.ldif

			echo "Verifying access to the LDAP server"
			/usr/local/bin/ldapsearch -x -b "" -s base "(objectclass=*)" namingContexts
			/usr/local/bin/ldapsearch -x -h localhost -b "dc=auth,dc=com"

		else
			echo "OpenLDAP setup must be installed as root. Type 'sudo ./openldap24.sh' for executing the script."
		fi
	else
		echo "OpenLDAP 2.4.39 requires Berkeley DB, installation aborted!"
	fi
fi
