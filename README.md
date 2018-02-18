-------------------------------------------------------------------------------
# CentOrion

A Vagrantfile plus a set of Bash scripts to configure
a software development VM with :

- CentOS 7.3 + Puppet 4.8.1 + VirtualBox Additions 5.1.xx
- Git
- Mercurial with HGK and Extension Queues

and optionally :

- Android Studio 3.0.1
- Ant 1.9.4
- Apache Directory Service 2.0
- Apache HTTPD 2.4.6 + PHP  5.4.16
- Berkeley DB 6.1 with Java bindings
- Cinnamon
- DCEVM
- Docker
- Cassandra 3.9 (requires Java 8 and Python 2.7)
- Eclipse 4.7 Oxygen
- Java 8.0 + JAI 1.1.3
- Hadoop 2.5.1
- HBase 1.1.2
- IntelliJ IDEA 3.4 Community
- Maven 3.2.1
- MySQL 5.1 + phpMyAdmin
- NodeJS 6.2.2 + Bower + Express
- OpenLDAP 2.4 + phpLDAPAdmin
- phpPgAdmin 5.1.2
- Play Framework 2.2.6
- PostGIS 2.0
- PostgreSQL 9.3 or 9.6
- Protocol Buffers 2.5.0
- Open Fire 3.9.3
- Ruby 2.2.6
- Scala 2.10 or 2.11
- Solr 6.1.0
- Tomcat 8.0 or 8.5
- VSFTP
- Zookeeper 3.4.6

The default install creates a minimal CentOS 7 virtual machine to start building a server or a development machine.

-------------------------------------------------------------------------------
# SETUP

1. Ensure that virtualization is enabled at your BIOS.

2. Install Oracle Virtual Box 5.1 or higher.

3. Install Vagrant 1.9 or higher.

	* If you are using a proxy with basic authentication (not NTLM), you will have to configure it for Bundler and Vagrant.
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
 
4. Download source from GitHub, if you have Git installed in your host then do :

`git clone https://github.com/sergiomt/centorion.git`

or else download and unzip

`https://github.com/sergiomt/centorion/archive/master.zip`

* If you are using a proxy, you will have to configure it for Git by doing `git config --global http.proxy http://_proxyuser_:_proxypwd_@_XXX.XXX.XXX.XXX_:_port_`

5. Optional. Copy an SSH key (id_dsa or id_rsa) authorized for your Git repository at vagrant-setup/.ssh/

6. Optional. Edit `setup.sh file .

7. Open a command prompt at the directory of this readme file and type:

	`vagrant up`

	That will create a virtual machine from scratch.
	It will usually take from 5 to 10 minutes depending on the speed of your Internet connection.

8. In the meantime, add
	`192.168.101.110 centorion`
	to your `/etc/hosts` or `C:\Windows\Sytem32\drivers\etc\hosts`

9. After creating the virtual machine move to its base directory in the host and connect to guest by doing:

	`vagrant ssh`

	or for connecting using PuTTY read
	[Connect to your Vagrant VM withPuTTY](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Connect-to-Your-Vagrant-Virtual-Machine-with-PuTTY)

10. Once logged into the Vagrant VM, from directory /vagrant/vagrant-setup run the .sh scripts for installing the desired applications.

11. You can also set what applications will be installed by default by changing INSTALLED_APPS in setup.sh

12. The guest machine has the private IP address 192.168.101.110

13. The base directory in the host is by default a shared folder between host and guest.

14. Optional. To save some disk space after install, you can delete the files at /vagrant/vagrant-setup/cache

## Troubleshooting

In case you have made any change to Vagrantfile then validate it with:

	`vagrant validate`

In case you need a full debug trace during VM creation you may use:

	`vagrant up -- debug > vagrant_debug.log 2>&1`

For watching your SSH configuration use:

	`vagrant ssh-config`

For trying to stablish an SSH connection with debug enabled use:

	`vagrant ssh -- -vvv`

At Vagrantfile, set `vb.gui = true` enable the GUI of VirtualBox and see whether the VM is waiting for input on startup

-------------------------------------------------------------------------------

# INSTALL APPLICATIONS ONE BY ONE

For each application there is a Bash shell script at /vagrant/vagrant-setup directory on the guest.

Most of these shell scripts must be execute as root by mean of:

`sudo /vagrant/vagrant-setup/*scriptname*.sh`

Some applications require others so order of installation is important.

Most of the scripts will either inform you about missing dependencies on other scripts or install the required dependencies themselves.

To fully automate application installation on machine creation, add the desired script names to INSTALLED_APPS variable in setup.sh

-------------------------------------------------------------------------------

# CENTOS 7.3

The password for **root** is **vagrant**

-------------------------------------------------------------------------------

# APACHE DIRECTORY SERVICE 2.0

It is installed at `/opt/apache-ds-2.0.0-M17`

Listens at port 10389

Manage with: `service apacheds [start|stop] default`

-------------------------------------------------------------------------------

# BERKELEY DB 6.2

It is installed at `/usr/share/db-6.2.32`

Includes Java bindings

-------------------------------------------------------------------------------

# DCEVM

Usually, it is not necessary to recompile [DCEVM](https://dcevm.github.io/)
because the JVM binaries for JDK 1.8.0_112 are already precompiled at
tomcat\dcevm

DCEVM is vey sensitive to any minor change in Java version,
so check its homepage for compatibility before performing any change on Java.

-------------------------------------------------------------------------------

# DOCKER

Docker is enabled to start on boot by default after install.
To disable start on boot do
`sudo systemctl disable docker`

The user **vagrant** is added to **docker** group.

-------------------------------------------------------------------------------

# JAVA 1.8.0_05 + JAI 1.1.3

It is installed at `/usr/java/jdk1.8.0_05`

-------------------------------------------------------------------------------

# CASSANDRA 3.9

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

# ECLIPSE 4.7 Oxygen

Is installed at `/usr/share/eclipse`

At /vagrant/vagrant-setup there are scripts for adding PyDev.

-------------------------------------------------------------------------------

# HADOOP 2.5.1

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

# HBASE 1.1.2

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

Is installed at `/usr/share/intellij`

-------------------------------------------------------------------------------

# MySQL 5.1

root password is vagrant

root remote login is disabled

test database is deleted

Start and stop with sudo service mysqld [start|stop]

Edit `/etc/httpd/conf.d/phpMyAdmin.conf` and `/etc/phpMyAdmin/config.inc.php`
for allowing access to phpMyAdmin from outside local host

-------------------------------------------------------------------------------

# NODEJS 6.2.2

Typescript quickstart files can be found at /vagrant/vagrant-setup/angular2

Create an application squeleton with
`./express application_name`

Use:
`npm start`
to start de server

Access Browsersync at
http://192.168.101.110:3001/

-------------------------------------------------------------------------------

# POSTGRESQL 9.3 or 9.6

It is installed at `/var/lib/pgsql`

SSH login for user postgres is disabled at `/etc/ssh/sshd_config`

User postgres does not have password, do not set password for postgres user,
use ident method within the server and another role for external access with pgAdmin.
Server is configured to accept connections from any client address,
see `/var/lib/pgsql/9.3/data/pg_hba.conf` and `postgresql.conf`

Start and stop with
`sudo service postgresql-9.3 [start|stop]`

-------------------------------------------------------------------------------

# PHPPGADMIN 5.1.2

Access from http://192.168.101.110/phpPgAdmin

-------------------------------------------------------------------------------

# OPEN FIRE 3.9.3

Start and stop Open Fire with sudo service openfire [start|stop]

After setup it is needed to do an initial setup using web administration console.

The web administration console can be accessed at http://192.168.101.110:9090

Set user admin and password 0p3nFir3

At Server Settings > File Transfer Proxy Settings,
it is neccessary to disable file transfer proxy on port 7777
If file transfer proxy is not disabled then when trying to connect
the following error is shown:
"couldn't setup local SOCKS5 proxy on port 7777"

The file transfer proxy needs to be disabled only if Open Fire client and
server are both running on the same machine.

-------------------------------------------------------------------------------

# OPENLDAP 2.4

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

PLAY FRAMEWORK 2.2.6

Should run under user **play** password **PlayFrm22**

-------------------------------------------------------------------------------

# RUBY 2.2.6, RAKE, BUNDLER

Ruby is installed at `/usr/local/rvm/rubies/ruby-2.1.0/`

RubyGems is installed at `/usr/local/rubygems`

-------------------------------------------------------------------------------

# SCALA 2.11.0

-------------------------------------------------------------------------------

# SOLR 6.1.0

Solr 6.1 requires Java 8.

Manage service with:
sudo service solr [start|stop -all]

The web administration console can be accessed at
http://192.168.101.110:8983/

Create a collection by entering:
`su - solr -c "/usr/share/solr/bin/solr create -c testcollection -n data_driven_schema_configs"`

-------------------------------------------------------------------------------

# TOMCAT 8.0 or 8.5

Start and stop with
`sudo service tomcat [start|stop|restart]`

It is installed at `/usr/share/tomcat`

Listens at port 8080.

Access Tomcat Manager by typing in your browser http://192.168.101.110:8080

Use **tomcat** user with password **catpassw8** for uploading files via SFTP

The User/Password for manager GUI is tomcat/catpassw8

Tomcat uses DCEVM as runtime for dynamic class reloading.

-------------------------------------------------------------------------------

# ZOOKEEPER 3.4.6

Runs on port 2181

Once installed, Zookeeper wil automatically start on boot.

To start and stop manually use
`sudo service zookeeper [start|stop]`

Start command line client with:
`/usr/share/zookeeper/bin/zkCli.sh -server 127.0.0.1:2181`
