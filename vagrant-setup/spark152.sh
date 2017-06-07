#!/bin/bash

# Install Spark 2.5.1 from source

if [ -d "/usr/share/spark" ]
	then

	echo "Spark is already installed, nothing done!"

else

		SETUP="/vagrant/vagrant-setup"
		PPWD=$PWD
		cd /usr/share

		SPARK=spark-1.5.2
		wget http://apache.mirror.anlx.net/spark/$SPARK/$SPARK.tgz
		mv $SPARK spark
fi


