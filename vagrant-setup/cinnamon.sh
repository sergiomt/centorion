#!/bin/bash

if [[ $EUID -eq 0 ]]
then
	SETUP="/vagrant/vagrant-setup"
	source $SETUP/include.sh
	
	yum -y install epel-release
	yum -y groupinstall "X Window system"
	
	yum -y install lightdm
	sudo systemctl enable lightdm.service
	
	# Alternatively, GDM can be used instead of LightDM
	# yum -y install gdm
	# sudo systemctl enable gdm.service
	
	yum -y install libnm-gtk
	yum -y install gtk-murrine-engine
	yum -y install cinnamon
	
	# Microsoft core fonts
	# wget_and_cp http://www.itzgeek.com/ msttcore-fonts-2.0-3.noarch.rpm
	# rpm -Uvh $SETUP/cache/msttcore-fonts-2.0-3.noarch.rpm
	yum -y install curl cabextract xorg-x11-font-utils fontconfig
	yum -y install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

	# Additional desktop programs
	yum -y install gnome-system-monitor
	yum -y install gnome-terminal
	yum -y install gedit
	yum -y install firefox
  sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
  sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
  sudo yum -y install sublime-text
	# yum -y groupinstall gnome-desktop

	systemctl set-default graphical.target

	# Change background
	cp $SETUP/cinnamon/cylon-wallpaper-1920x1080.jpg /usr/share/backgrounds/gnome/Cylon.jpg
	gsettings set org.cinnamon.desktop.background picture-uri "file:///usr/share/backgrounds/gnome/Cylon.jpg"
  su vagrant -c "gsettings set org.cinnamon.desktop.background picture-uri \"file:///usr/share/backgrounds/gnome/Cylon.jpg\""
	echo "Cinnamon successfully instaled. Please reboot the machine to complete setup."

else

	echo "Cinnamon must be installed as root. Type sudo ./cinnamon.sh for executing the script."

fi
