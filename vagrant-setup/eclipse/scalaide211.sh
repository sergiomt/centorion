#!/bin/bash

SETUP=/vagrant/vagrant-setup

sudo /usr/share/eclipse/eclipse -nosplash -application org.eclipse.equinox.p2.director \
-repository  jar:file://$SETUP/eclipse/scalaide/4.5.0-Scala-2.11.8.zip!/ \
-destination /usr/share/eclipse \
-installIU org.scala-ide.scala211.feature.feature.group,org.scala-ide.sdt.feature.feature.group
