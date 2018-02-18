-------------------------------------------------------------------------------
PREREQUISITES
-------------------------------------------------------------------------------

You need to have an SSH key with name id_dsa at /vagrant/vagrant-setup/.ssh or ~/.ssh
The SSH key must be authorized to clone and push to Clocial repositories.
The SSH key will be copied by the script to ~/.ssh

-------------------------------------------------------------------------------
QUICK START
-------------------------------------------------------------------------------

cd /vagrant/vagrant-setup
sudo /vagrant/vagrant-setup/clocial.sh > dev/null
./clocial-src.sh

Configure OpenFire from a web browser as described below.

sudo ./clocial-test-db.sh

-------------------------------------------------------------------------------
SETUP
-------------------------------------------------------------------------------

For setting up the software infrastructure required by Clocial execute:

sudo /vagrant/vagrant-setup/clocial.sh > dev/null

This will install:

	- Java 8.0
	- Scala 2.11
	- Tomcat 8.0
	- OpenLDAP 2.4
	- PostgreSQL 9.6
	- Berkeley DB 6.1
	- Hadoop 2.5.1
	- HBase 1.1.2
	- Open Fire

After installing the base software you'll probably want to download the source code
and to create a test database. Read the following sections for instructions on how
to do that.

Default connection strings for these datastores are located at the .cnf files at
/vagrant/vagrant-setup/clocial/etc/
these files are copied to /etc by clocial.sh script

-------------------------------------------------------------------------------
SOURCE CODE
-------------------------------------------------------------------------------

For downloading the source code you'll need an SSH key authorized at Git repositories.
The SSH key file name must be id_dsa or id_rsa and must be at ~/.ssh directory
(~/.ssh = /home/vagrant/.ssh for vagrant user or /root/.ssh for root user)
Key files should have chmod 600 permissions.

If you used PuTTY for generating the key then you'll need to export it to OpenSSH format.

If key is located at a different directory then first ensure that SSH agent is running by typing:
eval "$(ssh-agent -s)"
and add yor key with
ssh-add path/to/key/id_dsa

After adding your SSH key, set your identity at Git by doing:

git config --global user.name "Your First and last Name"
git config --global user.email yournickname@domain.com


For downloading and compiling Clocial source code do (as non-root):

cd /vagrant/vagrant-setup/
./clocial-src.sh

The project is fully mavenized.
You must first compile and install the subprojects at knowgate repository and
then the projects at clocial repository, in this order:

mvn compile clocial-pojo
mvn install clocial-pojo
mvn compile clocial-scala
mvn install clocial-scala
mvn compile clocial-web
mvn package clocial-web

More information on Git
-----------------------

Git Repos are located at

https://github.com/sergiomt/clocial

To clone the master branch do:

git clone https://github.com/sergiomt/clocial.git

To get only one file do:
git fetch
git branch -v
(this will give you a <revision> code needed at the next step)
git checkout -m <revision> <yourfilepath>
git add <yourfilepath>
git commit

To commit all changed files do:

git commit -am "Your Comments..."

To commit a single file or directory do:

git commit -m "Your Comments..." /path/to/file

To push changes to server do:

git push origin master

To remove a file do:

git rm filename.txt

-------------------------------------------------------------------------------
CONFIGURING OPEN FIRE
-------------------------------------------------------------------------------

The bash script clocial.sh creates and install an Openfire database on PostgreSQL.

Open
http://192.168.101.110:9090/
and for the database set
JDBC Driver = org.postgresql.Driver
Database URL = jdbc:postgresql://192.168.101.110:5432/openfire
Username = clocial
Password = clocial

For enabling LDAP authentication, at Profile Settings choose
(o) Directory Server (LDAP)
and set
Server Type = OpenLDAP
Host = 127.0.0.1
Port = 389
Base DN = dc=auth,dc=com
Administrator DN = cn=Manager,dc=auth,dc=com
Password = secret

The on next form Profile Settings: User Mapping set
Username Field = cn
click Advanced Settings and set
Search Fields = Nickname/sn
User Filters = (ou=Avatars)
Profile -> Nickname = {sn}

At Profile Settings: Group Mapping clear any grouping data

At Administrator Account set
Add Administrator = admin

Login to the administration console as user admin password secret

For more info on LDAP configuration read
https://www.igniterealtime.org/builds/openfire/docs/latest/documentation/ldap-guide.html

-------------------------------------------------------------------------------
TEST DATABASE
-------------------------------------------------------------------------------

clocial.sh creates an empty PostgreSQL test database with name clocialdev

You MUST have configured Open Fire before running the test database creation script.

To populate the test database do (as-non-root):

cd /vagrant/vagrant-setup/
./clocial-test-db.sh

Access the test database with user clocial password clocial

For connecting with psql as user clocial use conection string:

"postgresql://127.0.0.1:5432/clocialdev?user=clocial&password=clocial"

-------------------------------------------------------------------------------
TEST MAIL ACCOUNT
-------------------------------------------------------------------------------

Use clocial@inbox.com password 622|LkzUu-888 at my.inbox.com POP3+SMTP server

-------------------------------------------------------------------------------
ACCESING CLOCIAL FROM THE BROWSER
-------------------------------------------------------------------------------

Once the base software is installed, the source code compiled and the test db
is created, you can access a local instance of Clocial by opening the URL:

http://192.168.101.110:8080/clocial

The clocial webapp is symbolically linked to Maven target of clocial-web
Reinstalling the clocial-web project changes Tomcat webapp behaviour
DCEVM is used for avoiding the need of restarting Tomcat when Java classes are changed.
