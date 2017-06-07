#!/bin/bash

if [ -d "/usr/share/play" ]
	then
	echo "Play already installed, nothing done!"
else
		SETUP="/vagrant/vagrant-setup"
		source $SETUP/include.sh
		PPWD=$PWD
		cd /usr/share
		if getent passwd play > /dev/null 2>&1; then
			echo "play user already exists"
		else
	  	# Create a user for Play
	  	groupadd play
	  	useradd -d /usr/share/play/ -K MAIL_DIR=/dev/null -g play play
	  	echo -e "play\nplay\n" | passwd play
	  fi
		wget_and_unzip http://downloads.typesafe.com/play/2.2.6/ play-2.2.6.zip
		mv play-2.2.6 play
		cd play
		chown -Rf play.play .
		chmod -f -R 774 .
		if grep -Fq "/usr/share/play" ~/.bash_profile
		then
			echo "~/.bash_profile already contains /usr/share/play in PATH"
		else
			perl -pi -e "s/PATH=\x24PATH:/PATH=\x24PATH:\x2Fusr\x2Fshare\x2Fplay:/g" ~/.bash_profile
		fi
		iptables -A INPUT -p tcp --dport 8888 -j ACCEPT
		iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
		service iptables save
		service iptables restart
		cd $PPWD
fi