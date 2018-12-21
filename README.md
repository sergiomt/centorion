-------------------------------------------------------------------------------
# ![CentOrion](cylon-icon.png "CentOrion") CentOrion

A Vagrantfile plus a set of Bash scripts to full automate the configuration of a software development or server Linux VM.

This allows the distribution of virtual machines with very small file size (under 15Mb) compared to the tens of gigabytes required for a VM image.

The default install creates a minimal CentOS 7 virtual machine to start building a server or a development machine.

Video aceleration requires VirtualBox Additions 5.2.18 or later

- [CentOS 7.3](#centos-73)
- [Git](#git)
- Mercurial with HGK and Extension Queues

Then it is possible to install selectively the following applications.

- [Android Studio 3.0.1](#android-studio-301)
- [Ant 1.9.4](#ant-194)
- [Apache Directory Service 2.0](#apache-directory-service-20)
- [Apache HTTPD 2.4.6 + PHP 5.4.16](#apache-httpd-with-php)
- [Berkeley DB](#berkeley-db-60-61-or-62) 6.0, 6.1 or 6.2 with Java bindings
- [Cassandra 3.9](#cassandra-39) (requires Java 8 and Python 2.7)
- [Cinnamon](#cinnamon)
- [DCEVM](#dcevm) (requires Java 8)
- [Django 1.11.10](#django-11110)
- [Docker](#docker)
- [Eclipse 4.9](#eclipse-49)
- [Editix XML Editor](#editix-xml-ediotr)
- [Elasticsearch 6](#elasticsearch-6-with-x-pack)
- [Erlang](#erlang)
- [Java 8.0 + JAI 1.1.3](#java-180_162--jai-113)
- [Hadoop 2.8.5](#hadoop-285) (requires Java 8)
- [HBase 2.1.0](#hbase-2.1.0) (requires Hadoop)
- [IntelliJ IDEA 3.4 Community](#intellij-idea-34-community)
- [John The Ripper 1.8.0](#john-the-ripper-180)
- [Kibana 6](#kibana-6)
- [Kotlin](#kotlin) (requires SDKMAN)
- [Gradle 3.4.1](#gradle-341)
- [Groovy 2.4.13](#groovy-2413) (requires Java 8)
- [LAMP](#lamp) (MySQL + PHP + phpMyAdmin)
- [Logstash](#logstash)
- [Maven 3.2.1](vagrant-setup/maven321.sh)
- [MongoDB](#mongodb)
- [MySQL 5.6 + phpMyAdmin](#mysql-5639)
- [Nagios 4.1.1](#nagios-411)
- [NodeJS 6.2.2 + Bower + Express](#nodejs-622)
- [Open Fire 3.9.3](#open-fire-393)
- [OpenLDAP 2.4 + phpLDAPAdmin](#openldap-24)
- [Openshift 3.7.1](#openshift-371)
- [Oracle Express 11g2](#oracle-11g)
- [phpPgAdmin 5.1.2](#phppgadmin)
- [Play Framework 2.2.6](#play-framework-226)
- [PostgreSQL 9.3 or 9.6 + PostGIS 2.0 or 2.4](#postgresql-93-or-96)
- [Protocol Buffers 2.5.0](vagrant-setup/protobuf250.sh)
- [RabbitMQ 3.7.3](#rabbitmq-373)
- [Ruby 2.2.6](#ruby-226-rake-bundler)
- [Scala 2.10 or 2.11](#scala-210-or-211)
- [SDKMAN](#sdkman)
- [Selenium 2.42](#selenium-242)
- [Solr 6.1.0](#solr-610)
- [Tomcat 8.0 or 8.5](#tomcat-80-or-85)
- [VSFTP](vagrant-setup/vsftpd.sh)
- [Zookeeper 3.4.13](#zookeeper-3413)

-------------------------------------------------------------------------------
# SETUP

1. Ensure that virtualization is enabled at your BIOS.

2. Ensure that you have an ssh client in your host. If your host is Linux most probably is already there. If your host is Windows then install PuTTY, Cygwin or Git to get an ssh client as a side effect. Check that ssh executable is in your PATH.

3. [Install Oracle Virtual Box](https://www.virtualbox.org/wiki/Downloads) 5.1 or higher.

4. [Install Vagrant](https://www.vagrantup.com/downloads.html) 1.9 or higher.

	* Optional. If you are using a proxy with basic authentication (not NTLM), you will have to configure it for Bundler and Vagrant.
	* From your host command line do
		`SET HTTP_PROXY=http://_XXX.XXX.XXX.XXX_:_port_`
		`SET HTTPS_PROXY=ttp://_XXX.XXX.XXX.XXX_:_port_`
		`SET HTTP_PROXY_USER=_proxyuser_`
		`SET HTTPS_PROXY_USER=_proxyuser_`
		`SET HTTP_PROXY_PASS=_userpasswd_`
		`SET HTTPS_PROXY_PASS=_userpasswd_`
		on a Windows host, or
		`export HTTP_PROXY=http://_XXX.XXX.XXX.XXX_:_port_`
		`export HTTPS_PROXY=ttp://_XXX.XXX.XXX.XXX_:_port_`
		`export HTTP_PROXY_USER=_proxyuser_`
		`export HTTPS_PROXY_USER=_proxyuser_`
		`export HTTP_PROXY_PASS=_userpasswd_`
		`export HTTPS_PROXY_PASS=_userpasswd_`
		on a Linux host.
	* From the command line `vagrant plugin install vagrant-proxyconf-1.5.2.gem`
	* Last edit Vagrantfile and change config.proxy.http, config.proxy.https and config.proxy.no_proxy values to the right IP and port and user/password.
 
5. Download source from GitHub, if you have Git installed in your host then do :

	`git clone https://github.com/sergiomt/centorion.git`

	* If you are using a proxy, you will have to configure it for Git by doing `git config --global http.proxy http://_proxyuser_:_proxypwd_@_XXX.XXX.XXX.XXX_:_port_`

	Or if you do not have Git in your host then download and unzip

	`https://github.com/sergiomt/centorion/archive/master.zip`

6. Optional (you can do this later). If you are going to install a graphical user interface then edit Vagrantfile and set [vb.gui = true](https://www.vagrantup.com/docs/virtualbox/configuration.html).

7. Optional (you can do this later). If you are going to use an SSH key then copy then SSH key (id_dsa or id_rsa) authorized for your Git repository at vagrant-setup/.ssh/

8. Optional. Edit `setup.sh` file and set what applications will be installed by default by changing `INSTALLED_APPS`.

9. Open a command prompt at the directory of this README file and type:

	`vagrant up CentOrion`

	That will create a virtual machine from scratch.
	It will usually take from 5 to 10 minutes depending on the speed of your Internet connection.

	If your are setting up an Openshift cluster then your command must be:

	`vagrant up openshift-master openshift-node1`

10. In the meantime, add the line
	`192.168.101.110 centorion`
	to your host machine hosts file which will be at `/etc/hosts` in Linux or at `C:\Windows\Sytem32\drivers\etc\hosts` in Windows.

	If you are setting up an Openshift cluster then add at hosts:

	`192.168.101.111 openshift-master`

	`192.168.101.112 openshift-node1`

11. After creating the virtual machine move to its base directory in the host and connect to guest by doing:

	`vagrant ssh CentOrion`

	or for connecting using PuTTY read
	[Connect to your Vagrant VM withPuTTY](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Connect-to-Your-Vagrant-Virtual-Machine-with-PuTTY).

12. Once logged into the Vagrant VM, from directory `/vagrant/vagrant-setup` run the selected Bash (.sh) scripts for installing the desired applications. For example, a basic Tomcat 8 server deployment could consist of: java80.sh, maven321.sh and tomcat80.sh. The order of execution of the scripts is important.

13. The guest machine has the private IP address 192.168.101.110

14. The base directory in the host is by default a shared folder between host and guest.

15. Optional. To save some disk space after install, you can delete the files at `/vagrant/vagrant-setup/cache` This is not recommended if you are going to create, destroy, re-create the virtual machine more than once because the set up scripts keep a local copy of downloaded packages, so with cache the second time that you create your VM the process will be much faster and use far less bandwidth.

## Troubleshooting

In case you have made any change to Vagrantfile then validate it with:

	`vagrant validate`

In case you need a full debug trace during VM creation you may use:

	`vagrant up machine_name -- debug > vagrant_debug.log 2>&1`

For watching your SSH configuration use:

	`vagrant ssh-config`

For trying to stablish an SSH connection with debug enabled use:

	`vagrant ssh -- -vvv`

At Vagrantfile, set `vb.gui = true` enable the GUI of VirtualBox and see whether the VM is waiting for input on startup

-------------------------------------------------------------------------------

# INSTALL APPLICATIONS ONE BY ONE

For each application there is a Bash shell script at /vagrant/vagrant-setup directory on the guest.

Most of these shell scripts must be execute as root by mean of:

`sudo /vagrant/vagrant-setup/the_script_name.sh`

Some applications require others so order of installation is important.

Most of the scripts will either inform you about missing dependencies on other scripts or install the required dependencies themselves.

To fully automate application installation on machine creation, add the desired script names to `INSTALLED_APPS` variable in [setup.sh](vagrant-setup/setup.sh)

-------------------------------------------------------------------------------

# HOW TO REBUILD THE BASE BOX

A VirtualBox base box is required at Vagrant file vs.vm.box_url

If a box is not available, it can be created using [Packer](https://www.packer.io/intro/index.html).

For building the base box, download [download Packer](https://www.packer.io/downloads.html) then change to the /packer subdirectory of CentOrion.

Execute:

`packer build -var-file=variables-centos-7.3.json vagrant-centos.json`

This will create a base box name `vagrant-centos-73.box` that can be referenced from Vagrantfile.

Read more on Vagrant provisioners [here](https://www.packer.io/docs/provisioners/shell.html).

-------------------------------------------------------------------------------

# CENTOS 7.3

The password for **root** and **vagrant** users is **vagrant**

-------------------------------------------------------------------------------

# ANDROID STUDIO 3.0.1

[Installation Script](vagrant-setup/androidstudio301.sh)

-------------------------------------------------------------------------------

# ANT 1.9.4

[Installation Script](vagrant-setup/ant194.sh)

-------------------------------------------------------------------------------

# APACHE DIRECTORY SERVICE 2.0

[Installation Script](vagrant-setup/ads200.sh)

It is installed at `/opt/apache-ds-2.0.0-M17`

Listens at port 10389

Manage with: `service apacheds [start|stop] default`

-------------------------------------------------------------------------------

# APACHE HTTPD WITH PHP

[Installation Script](vagrant-setup/httpd.sh)

-------------------------------------------------------------------------------

# BERKELEY DB 6.0, 6.1 OR 6.2

Installation Scripts [6.0](vagrant-setup/db60.sh), [6.1](vagrant-setup/db61.sh), [6.2](vagrant-setup/db62.sh),

Latest version 6.2 is installed at `/usr/share/db-6.2.32`

Includes Java bindings

The user **vagrant** is added to **docker** group.

-------------------------------------------------------------------------------

# CASSANDRA 3.9

[Installation Script](vagrant-setup/cassandra39.sh)

Cassandra 3.9 requires Java 8 or later.

Start and stop with
`sudo service cassandra [start|stop|status]`

Enter the Cassandra Command Line with:
`cqlsh`

Check Cassandra Node Status with:
`nodetool status`

Start Opscenter with:
`/usr/share/opscenter/bin/opscenter`
(use -f option to start as foreground process)

Access OpsCenter through:
http://192.168.101.110:8888/

Configuration documentation
http://docs.datastax.com/en/cassandra/3.x/cassandra/configuration/configTOC.html

-------------------------------------------------------------------------------

# CINNAMON

[Installation Script](vagrant-setup/cinnamon.sh)

The version of Cinnamon installed is chosen by yum package installer.

Installing Cinnamon will require at least one guest reboot and maybe more.

**Before starting to install Cinnamon set `vb.gui = true` at Vagrantfile** to enable GUI.

It is also recommended that you enable **3D acceleration** in VirtualBox screen settings, otherwise you'll get a "Cinnamon is using software rendering mode" warning you about degraded UI performance.

A few GNOME applications are installed by default:

* GNOME Terminal
* GNOME System Monitor
* GEdit
* Sublime Text
* Mozilla Firefox

In order to install Cinnamon you must run once:
`sudo cinnamon.sh`
from /vagrant/vagrant-setup
and after the script finishes executing reboot the guest virtual machine.

-------------------------------------------------------------------------------

# DCEVM

Usually, it is not necessary to recompile [DCEVM](https://dcevm.github.io/)
because the JVM binaries for JDK 1.8.0_05, 1.8.0_112 and 1.8.0_162 are already
precompiled at [tomcat/dcevm](vagrant-setup/tomcat/dcevm)

DCEVM is very sensitive to any minor change in Java version,
so check its homepage for compatibility before performing any change on Java.

-------------------------------------------------------------------------------

# DJANGO 1.11.10

[Installation Script](vagrant-setup/django.sh)

Django is installed with the `virtualenv` tool. This tool allows to create virtual Python environments where you can install any Python packages you want without affecting the rest of the system.

Python projects are put at `/home/vagrant/pythonprojects` where a default environment called `env1` is atomatically created. Then Django is installed on the env1 virtualenvironment.

`virtualenv` does not work properly on folders shared between the host and the guest, read [here](https://github.com/gratipay/gratipay.com/issues/2327) the gory details.

Before using any virtualenvironment you must activate it with
`source environment_name/bin/activate`

To create a new project in an evironment type:
`django-admin startproject projectname`

To bootstrap the database (which uses SQLite by default) type:
`python manage.py migrate`

You can create an administrative user by typing:
`python manage.py createsuperuser`

Once you have a user, you can start up the Django development server. You should only use this for development purposes. Run:
`python manage.py runserver 0.0.0.0:8000`

-------------------------------------------------------------------------------

# DOCKER

[Installation Script](vagrant-setup/docker.sh)

Docker is enabled to start on boot by default after install.
To disable start on boot do
`sudo systemctl disable docker`

-------------------------------------------------------------------------------

# ECLIPSE 4.9

[Installation Script](vagrant-setup/eclipse49.sh)

Is installed at `/usr/share/eclipse`

At `/vagrant/vagrant-setup/eclipse` there are scripts for adding PyDev.

Scala 2.10 or 2.11 require an [older releases of the Scala IDE for Eclipse](http://scala-ide.org/download/prev-stable.html)
To install Scala IDE 4.5.0 for Scala 2.11.8 use this [installation Script](vagrant-setup/eclipse/scalaide211.sh) after having installed Eclipse.

-------------------------------------------------------------------------------

EDITIX XML EDITOR

[Installation Script](vagrant-setup/editix.sh)

Requires Ant.

It is installed at `/usr/share/editix`

Launch with `ant run`

-------------------------------------------------------------------------------

# ELASTICSEARCH 6 WITH X-PACK

[Installation Script](vagrant-setup/elasticsearch6.sh)

It's installed at `/usr/share/elasticsearch`

To configure Elasticsearch to start automatically when the system boots up, run the following commands:

`sudo /bin/systemctl daemon-reload`
`sudo /bin/systemctl enable elasticsearch.service`

Elasticsearch can be started and stopped as follows:

`sudo systemctl start elasticsearch.service`
`sudo systemctl stop elasticsearch.service`

These commands provide no feedback as to whether Elasticsearch was started successfully or not. Instead, this information will be written in the log files located in `/var/log/elasticsearch/`.

By default the Elasticsearch service doesn’t log information in the `systemd` journal. To enable `journalctl` logging, the `--quiet` option must be removed from the ExecStart command line in the `elasticsearch.service` file.

When systemd logging is enabled, the logging information are available using the `journalctl` commands:

To tail the journal:

`sudo journalctl -f`

To list journal entries for the elasticsearch service:

`sudo journalctl --unit elasticsearch`

To list journal entries for the elasticsearch service starting from a given time:

`sudo journalctl --unit elasticsearch --since  "2016-10-30 18:17:16"`

Check man `journalctl` or https://www.freedesktop.org/software/systemd/man/journalctl.html for more command line options.

You can test that your Elasticsearch node is running by sending an HTTP request to port 9200 on localhost: `GET /` which should give a JSON object as response.

Elasticsearch defaults to using /etc/elasticsearch for runtime configuration. The ownership of this directory and all files in this directory are set to root:elasticsearch on package installation and the directory has the setgid flag set so that any files and subdirectories created under /etc/elasticsearch are created with this ownership as well (e.g., if a keystore is created using the keystore tool). It is expected that this be maintained so that the Elasticsearch process can read the files under this directory via the group permissions.

Elasticsearch loads its configuration from the `/etc/elasticsearch/elasticsearch.yml` file by default. The format of this config file is explained in Configuring Elasticsearch.

The RPM also has a system configuration file `/etc/sysconfig/elasticsearch`. 

Read more at:

* [Configuring Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html)
* [Important Elasticsearch configuration](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html)
* [Important System Configuration](https://www.elastic.co/guide/en/elasticsearch/reference/current/system-config.html)

-------------------------------------------------------------------------------

# ERLANG

[Installation Script](vagrant-setup/erlang.sh)

-------------------------------------------------------------------------------

# GIT

To [use an SSH key on Github](https://help.github.com/articles/connecting-to-github-with-ssh/) instead of user/password, save the private key at ~/.ssh add this to ~/.ssh/config

Host www.github.com
   HostName github.com
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
   IdentityFile ~/.ssh/id_dsa
   User git

then execute
`git config core.sshCommand "ssh -i ~/.ssh/id_dsa -F /dev/null"`

last in your shell run [addsshagentkey.sh](vagrant-setup/addsshagentkey.sh)

To use Meld as merge tool execute
`sudo yum install meld`
and add this to your `.gitconfig` file.
`
[diff]
    tool = meld
[difftool]
    prompt = false
[difftool "meld"]
    cmd = meld "$LOCAL" "$REMOTE"
`

-------------------------------------------------------------------------------

# GRADLE 3.4.1

[Installation Script](vagrant-setup/gradle341.sh)

Is installed at `/usr/local/gradle`

-------------------------------------------------------------------------------

# GROOVY 2.4.13

[Installation Script](vagrant-setup/groovy24.sh)

Is installed at `/usr/local/groovy`

You can test installation by typing in a command shell:

`/usr/local/groovy/bin/groovysh`

Which should create an interactive groovy shell where you can type Groovy statements.

Or to run the Swing interactive console type:

`groovyConsole`

To run a specific Groovy script type:

`groovy SomeScript`

-------------------------------------------------------------------------------

# HADOOP 2.8.5

[Installation Script](vagrant-setup/hadoop285.sh)

Hadoop will be compiled from source in order to generate its native libraries.
Protocol Buffers will be installed as a side effect of installing Hadoop.

The installation script copies native libraries to `/usr/local/lib`

Ensure that port 9001 is added at `/etc/ssh/sshd_config`

Runs under user hadoop

Start and stop HDFS and Yarn with
`sudo service hadoop [start|stop]`

Cluster Manager is at http://192.168.101.110:8088/

Node HTTP address is http://192.168.101.110:8042/

-------------------------------------------------------------------------------

# HBASE 2.1.0

[Installation Script](vagrant-setup/hbase112.sh)

The recommended Hadoop version is [2.7.7](vagrant-setup/hadoop277.sh)

Older [HBase 1.1.2](vagrant-setup/hbase112.sh) requires [Hadoop 2.5.1](vagrant-setup/hadoop251.sh)

It is installed in pseudo-distributed mode with unmanaged Zookeeper at
`/usr/share/hbase`

Runs under the same user as Hadoop

Start and stop with
`sudo service hbase [start|stop]`

Web console is at
http://192.168.101.110:16010/

Read about architecture at
https://www.mapr.com/blog/in-depth-look-hbase-architecture

For distributed set up read
https://cyberfrontierlabs.com/2014/09/30/getting-started-with-distributed-hbase-and-zookeeper/

For conf/hbase-site.xml config see
* http://hbase.apache.org/book.html
* http://jayatiatblogs.blogspot.co.uk/2013/01/hbase-installation-fully-distributed.html
* https://github.com/apache/hbase/blob/master/hbase-common/src/main/resources/hbase-default.xml

Start the command line client with
`/usr/share/hbase/bin/hbase shell`

For hbase shell commands see
https://learnhbase.wordpress.com/2013/03/02/hbase-shell-commands/

-------------------------------------------------------------------------------

# INTELLIJ IDEA 3.4 COMMUNITY

[Installation Script](vagrant-setup/intellij34.sh)

After the initial setup **you must upgrade to the latest JDK** following [these](https://intellij-support.jetbrains.com/hc/en-us/articles/206544879-selecting-the-jdk-version-the-ide-will-run-under) instructions.
IntelliJ Open File dialogs won't work with Java 1.8.0_05.

The IDE is installed at `/usr/share/intellij`

Start it with `idea` from any location (the symbolic link points to /usr/share/intellij/bin/idea.sh

-------------------------------------------------------------------------------

# JAVA 1.8.0_162 + JAI 1.1.3

[Installation Script](vagrant-setup/java80.sh)

By default, it is installed at `/usr/java/jdk1.8.0_162`

To change the minor version which is installed, edit the installation script and change JDK, RPM and OTN variables.

-------------------------------------------------------------------------------

JOHN THE RIPPER 1.8.0

[Installation Script](vagrant-setup/johntheripper180.sh)

It is installed at `/usr/share/john`

Test installation by executing
`/usr/share/john/run/john --test`

To get extra charset files download and uncompress
http://www.openwall.com/john/j/john-extra-20130529.tar.xz

-------------------------------------------------------------------------------

# KIBANA 6

[Installation Script](vagrant-setup/kibana6.sh)

It is installed at `/usr/share/kibana`

To configure Kibana to start automatically when the system boots up, run the following commands:

`sudo /bin/systemctl daemon-reload`
`sudo /bin/systemctl enable kibana.service`

Kibana can be started and stopped as follows:

`sudo systemctl [start|stop] kibana.service`

Kibana loads its configuration from the `/etc/kibana/kibana.yml` file by default. The format of this config file is explained in [Configuring Kibana](https://www.elastic.co/guide/en/kibana/6.2/settings.html).

Kibana is a web application that you access through port 5601. All you need to do is point your web browser at the machine where Kibana is running and specify the port number. For example, http://localhost:5601 or http://192.168.101.110:5601

When you access Kibana, the Discover page loads by default with the default index pattern selected. The time filter is set to the last 15 minutes and the search query is set to match-all (\*).

Before you can start using Kibana, you need to tell it which Elasticsearch indices you want to explore. The first time you access Kibana, you are prompted to define an index pattern that matches the name of one or more of your indices. You can add index patterns at any time from the Management tab.

By default, Kibana connects to the Elasticsearch instance running on localhost. To connect to a different Elasticsearch instance, modify the Elasticsearch URL in the kibana.yml configuration file and restart Kibana.

-------------------------------------------------------------------------------

# KOTLIN

[Installation Script](vagrant-setup/kotlin.sh)

-------------------------------------------------------------------------------

# LAMP

[Installation Script](vagrant-setup/lamp.sh)

-------------------------------------------------------------------------------

# LOGSTASH

[Installation Script](vagrant-setup/logstash6.sh)

Start and stop service with

`sudo systemctl [start|stop] logstash.service`

See also [Running Logstash from the Command Line](https://www.elastic.co/guide/en/logstash/6.2/running-logstash-command-line.html)

-------------------------------------------------------------------------------

# NAGIOS 4.1.1

[Installation Script](vagrant-setup/nagios411.sh)

It is installed at `/usr/share/nagios`

The installation includes plugins 2.1.1 and NRPE 2.15.

Should run under user **nagios** password **nagpasswd4**

To access Nagios through its web interface open URL

http://192.168.101.110/nagios

User **nagiosadmin** password **nagpasswd4**

To configure Nagios contacts, edit the contacts configuration:

`sudo vi /usr/local/nagios/etc/objects/contacts.cfg`

Find the email directive, and replace its value (the highlighted part) with your own email address:

`email	nagios@localhost	; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS **`

To restrict Access by IP Address

Edit the Apache configuration file:

`sudo vi /etc/httpd/conf.d/nagios.conf`

Find and comment the following two lines by adding # symbols in front of them:

`Order allow,deny`
`Allow from all`

Then uncomment the following lines, by deleting the # symbols, and add the IP addresses or ranges (space delimited) that you want to allow to in the Allow from line:

`#  Order deny,allow`
`#  Deny from all`
`#  Allow from 127.0.0.1`

As these lines will appear twice in the configuration file, so you will need to perform these steps once more.

Save and exit.

-------------------------------------------------------------------------------

MONGODB

[Installation Script](vagrant-setup/mongodb.sh)

It´s installed with yum, so the exact version will depend on the repository.

To install a specific release of MongoDB, change the script to specify each package individually, as in the following example:
`sudo yum install -y mongodb-org-4.0.2 mongodb-org-server-4.0.2 mongodb-org-shell-4.0.2 mongodb-org-mongos-4.0.2 mongodb-org-tools-4.0.2`

Start and stop with
`sudo service mongod [start|stop|restart]`

Verify that MongoDB has started successfully by searching for the string
`[initandlisten] waiting for connections on port <port>`
in /var/log/mongodb/mongod.log

Optionally, start MongoDB on boot by issuing the following command:
`sudo chkconfig mongod on`

Start a mongo shell on the same host machine as the mongod. Use the --host command line option to specify the localhost address (in this case 127.0.0.1) and port that the mongod listens on:
`mongo --host 127.0.0.1:27017`

-------------------------------------------------------------------------------

# MySQL 5.6.39

[Installation Script](vagrant-setup/mysql.sh)

**root** password is **vagrant**

root remote login is disabled

test database is deleted

Start and stop with sudo service mysqld [start|stop]

Edit `/etc/httpd/conf.d/phpMyAdmin.conf` and `/etc/phpMyAdmin/config.inc.php`
for allowing access to phpMyAdmin from outside local host

-------------------------------------------------------------------------------

# NODEJS 6.2.2

[Installation Script](vagrant-setup/nodejs622.sh)

Typescript quickstart files can be found at /vagrant/vagrant-setup/angular2

Create an application squeleton with
`./express application_name`

Use:
`npm start`
to start de server

Access Browsersync at
http://192.168.101.110:3001/

-------------------------------------------------------------------------------

# OPEN FIRE 3.9.3

[Installation Script](vagrant-setup/openfire393.sh)

Start and stop Open Fire with sudo service openfire [start|stop]

After setup it is needed to do an initial setup using web administration console.

The web administration console can be accessed at http://192.168.101.110:9090

Set user admin and password **0p3nFir3**

At Server Settings > File Transfer Proxy Settings,
it is neccessary to disable file transfer proxy on port 7777
If file transfer proxy is not disabled then when trying to connect
the following error is shown:
"couldn't setup local SOCKS5 proxy on port 7777"

The file transfer proxy needs to be disabled only if Open Fire client and
server are both running on the same machine.

-------------------------------------------------------------------------------

# OPENLDAP 2.4

[Installation Script](vagrant-setup/openldap24.sh)

OpenLDAP is compiled with TCP Wrappers and using Berkeley DB 6.2 as database.

If HTTPD is installed then OpenLDAP script installs phpLDAPAdmin as well
which can be accessed through:

A database with suffix dc=auth,dc=com is created at `/usr/local/var/auth-data`

Manage service with:
`sudo service slapd [start|stop]`

phpLDAPAdmin is accessed from http://192.168.101.110/ldapadmin/
Login to phpLDAPAdmin as cn=Manager,dc=auth,dc=com with password secret

http://www.yolinux.com/TUTORIALS/LinuxTutorialLDAP-SLAPD-LDIF-V2-config.html
http://www.openldap.org/lists/openldap-technical/201403/msg00001.html

-------------------------------------------------------------------------------

# OPENSHIFT 3.7.1

The default setup will create an Openshift cluster with one master and one node.

After having executed from the host:
`vagrant up openshift-master openshift-node1`
you must log into the openshift-master virtual machine by doing:
`vagrant ssh openshift-master`
from the host and then inside the guest master execute:

`sudo /vagrant/vagrant-setup/openshift-ansible.sh`

After install, you can log into Openshift at:
https://192.168.101.111:8443/console/
with user **admin** and password **admin"

-------------------------------------------------------------------------------

# ORACLE 11G

## Prerequisites

Before running the install script you must have an Oracle OTN account to download
http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip
and save it at `/vagrant/vagrant-setup/cache`

Oracle Database needs a swap space of at least 2048 Mb which is more that the default of 1279 Mb that comes out of the box. 
So before you begin and with the VM halted, you must add a new virtual hard disk from Virtualbox by right clicking on the machine and then Configuration -> Storage.
Click on the icon of a hard drive with a + sign and add a new disk of 2Gb fixed size.

After adding the new hard disk do `vagrant up machine_name`

Once logged in type:

`sudo vgdisplay`
this will display the volume group information showing something like:
VG Name **cl**

Then execute
`sudo fdisk -l`
to list the available drives.
You should get in the list **/dev/hdb** or **/dev/sdb** depending on whether you are using spinning or solid states physical drives.

Now execute:
`
sudo pvcreate /dev/sdb
sudo vgextend cl /dev/sdb
sudo lvextend -L+2G /dev/cl/swap
`
this will add 2Gb to the swap space.

Now you can start installation by running the provided Bash script.

## Install

[Installation Script](vagrant-setup/oracle11g2.sh)

## Post installation configuration

As part of the installation process, the script will automatically initiate oracle-xe configure which will interactively ask you questions about which ports must be used and whether Oracle must start on boot or not.

If you are using a GUI like Cinnamon then you can also install **SQL Developer**.
As for the database, you need an OTN account to download SQL Developer from
http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html
Then install it with
`rpm -Uhv sqldeveloper-(build number)-1.noarch.rpm`

-------------------------------------------------------------------------------

# POSTGRESQL 9.3 or 9.6

Installation Scripts [9.3](pgsql93.sh), [9.6](pgsql96.sh)

It is installed at `/var/lib/pgsql`

SSH login for user postgres is disabled at `/etc/ssh/sshd_config`

User postgres does not have password, do not set password for postgres user,
use ident method within the server and another role for external access with pgAdmin.
Server is configured to accept connections from any client address,
see `/var/lib/pgsql/9.3/data/pg_hba.conf` and `postgresql.conf`

Start and stop with
`sudo service postgresql-9.3 [start|stop]`
or
`sudo systemctl [start|stop] postgresql-9.6.service`

-------------------------------------------------------------------------------

# PHPPGADMIN

[Installation Script](vagrant-setup/phppgadmin.sh)

Access from http://192.168.101.110/phpPgAdmin

-------------------------------------------------------------------------------

# PLAY FRAMEWORK 2.2.6

[Installation Script](vagrant-setup/play226.sh)

Should run under user **play** password **PlayFrm22**

-------------------------------------------------------------------------------

RABBITMQ 3.7.3

[Installation Script](vagrant-setup/rabbitmq373.sh)

Requires Erlang which is automatically installed if not already present.

For additional configuration steps that might be required read
https://www.rabbitmq.com/install-rpm.html

-------------------------------------------------------------------------------

# RUBY 2.2.6, RAKE, BUNDLER

[Installation Script](vagrant-setup/ruby226.sh)

Ruby is installed at `/usr/local/rvm/rubies/ruby-2.1.0/`

RubyGems is installed at `/usr/local/rubygems`

-------------------------------------------------------------------------------

# SCALA 2.10 or 2.11 or 2.12

Installation Scripts [2.10](vagrant-setup/scala210.sh), [2.11](vagrant-setup/scala211.sh), [2.12](vagrant-setup/scala212.sh)

-------------------------------------------------------------------------------

# SDKMAN

[Installation Script](vagrant-setup/sdkman.sh)

-------------------------------------------------------------------------------

# SELENIUM 2.42

[Installation Script](vagrant-setup/selenium242.sh)

To start Selenium Server execute:

`Xvfb :1 -screen 0 800x600x24&`
`export DISPLAY=localhost:1.0`
`java -jar selenium-server-standalone-2.42.2.jar &`

-------------------------------------------------------------------------------

# SOLR 6.1.0

[Installation Script](vagrant-setup/solr610.sh)

Solr 6.1 requires Java 8.

Manage service with:
sudo service solr [start|stop -all]

The web administration console can be accessed at
http://192.168.101.110:8983/

Create a collection by entering:
`su - solr -c "/usr/share/solr/bin/solr create -c testcollection -n data_driven_schema_configs"`

-------------------------------------------------------------------------------

# TOMCAT 8.0 or 8.5

Installation Scripts [8.0](vagrant-setup/tomcat80.sh), [8.5](vagrant-setup/tomcat85.sh)

Tomcat 8.5 requires [Open SSL 1.0.2](vagrant-setup/openssl102.sh).

Start and stop with
`sudo service tomcat [start|stop|restart]`

It is installed at `/usr/share/tomcat`

Listens at port 8080.

Access Tomcat Manager by typing in your browser http://192.168.101.110:8080

Use **tomcat** user with password **catpassw8** for uploading files via SFTP

The User/Password for manager GUI is **tomcat/catpassw8**

Tomcat uses DCEVM as runtime for dynamic class reloading.
To use standard JRE edit [init.d/tomcat](vagrant-setup/tomcat/init.d/tomcat) and remove
`-XXaltjvm=dcevm -javaagent:/usr/share/tomcat/lib/hotswap-agent-1.1.0.jar=autoHotswap=true`
from `JAVA_OPTS`

-------------------------------------------------------------------------------

# ZOOKEEPER 3.4.13

[Installation Script](vagrant-setup/zookeeper3413.sh)

Runs on port 2181

Once installed, Zookeeper wil automatically start on boot.

To start and stop manually use
`sudo service zookeeper [start|stop]`

Start command line client with:
`/usr/share/zookeeper/bin/zkCli.sh -server 127.0.0.1:2181`
