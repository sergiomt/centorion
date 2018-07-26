#!/bin/bash

if [ ! -d "/usr/local/ant" ]
then

	echo "Editix XML Editor requires Ant. Please install Ant first. Nothing Done!"

else

	echo "Installing Editix XML Editor..."
	source /vagrant/vagrant-setup/include.sh
	cd /usr/share
	git clone https://github.com/AlexandreBrillant/Editix-xml-editor.git
	mv Editix-xml-editor editix
	cd $PPWD

fi