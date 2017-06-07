#!/bin/bash

source /vagrant/vagrant-setup/include.sh

SHARED=/usr/share/tomcat/shared/lib
WEBINF=/usr/share/tomcat/webapps/clocial/WEB-INF/lib

sudo service apacheds stop default

sudo $JAVA_HOME/bin/java -cp /opt/apacheds-2.0.0-M17/lib/*:$SHARED/*:/vagrant/knowgate/knowgate-core/target/knowgate-core-8.0.jar:/vagrant/clocial/clocial-pojo/target/clocial-pojo-1.0.jar com.clocial.datamodel.ClocialApacheDSPartitioner /var/lib/apacheds-2.0.0-M17/default test-clocial01

sudo service apacheds start default
