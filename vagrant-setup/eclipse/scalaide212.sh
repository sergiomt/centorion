#!/bin/bash

SETUP=/vagrant/vagrant-setup

sudo /usr/share/eclipse/eclipse -nosplash -application org.eclipse.equinox.p2.director \
-repository  jar:file://$SETUP/eclipse/scalaide/4.7.0-Scala-2.12.3.zip!/ \
-destination /usr/share/eclipse \
-installIU org.scala-ide.scala212.feature.feature.group,org.scala-ide.sdt.feature.feature.group
