#!/usr/bin/env python
# Add PyDev's certificate to Java's key and certificate database
# Certificate file can be downloaded here : http://pydev.org/pydev_certificate.cer
import os, sys
import pexpect

print "Adding pydev_certificate.cer to /usr/java/default/jre/lib/security/cacerts"

cwd = os.path.abspath (os.path.dirname(sys.argv[0]))
child = pexpect.spawn("keytool -import -file ./pydev_certificate.cer -keystore /usr/java/default/jre/lib/security/cacerts")
child.expect("Enter keystore password:")
child.sendline("changeit")
if child.expect(["Trust this certificate?", "already exists"]) == 0:
    child.sendline("yes")
try:
    child.interact()
except OSError:
    pass

print "PyDev self-signed certificate installed."
