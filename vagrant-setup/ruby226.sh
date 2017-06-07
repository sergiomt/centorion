#!/bin/bash

SETUP="/vagrant/vagrant-setup"
source $SETUP/include.sh

PPWD=$PWD

# Install mpapis public key
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

curl -L get.rvm.io | bash -s stable
usermod -G rvm vagrant
source /etc/profile.d/rvm.sh
rvm reload
rvm install 2.2.6 --disable-binary

# Uncomment this line to install documentation
# rvm docs generate-ri

ln -s /usr/local/rvm/rubies/ruby-2.2.6/bin/ruby /usr/local/bin/ruby
ln -s /usr/local/rvm/rubies/ruby-2.2.6/bin/gem /usr/local/bin/gem

gem install rake

ln -s /usr/local/rvm/rubies/ruby-2.2.6/lib/ruby/gems/2.2.0/wrappers/rake /usr/local/bin/rake

gem install bundler

ln -s /usr/local/rvm/rubies/ruby-2.2.6/lib/ruby/gems/2.2.0/wrappers/bundle /usr/local/bin/bundle

cd $PPWD
