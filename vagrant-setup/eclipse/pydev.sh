#!/bin/bash

sudo /usr/share/eclipse/eclipse -nosplash -application org.eclipse.equinox.p2.director -repository http://pydev.org/updates/ -destination /usr/share/eclipse -installIU org.python.pydev.feature.feature.group
