#!/bin/bash

SETUP="/vagrant/vagrant-setup"
source $SETUP/include.sh

if isinstalled docker-ce
then

	echo "Jenkins is already installed. Nothing Done!"

else

	if [[ $EUID -eq 0 ]]
	then

		curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | tee /etc/yum.repos.d/jenkins.repo
		rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
		yum install jenkins
		perl -pi -e "s/JENKINS_PORT=\x228080\x22/JENKINS_PORT=\x228087\x22/g" /etc/sysconfig/jenkins

		echo "Jenkins installation completed. Jenkins running on port 8087"

	else

		echo "Jenkins must be installed as root. Type sudo ./jenkins.sh for executing the script."

	fi
fi
