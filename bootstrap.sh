#!/bin/bash
# Bootstrap
# By Jesse Collier <jessecollier@gmail.com>
# November 15th, 2013

# This script assumes the following
# - You are running ubuntu
# - Your base image includes a cronjob 
#   that downloads and executes this bootstrap

if [ ! -a /etc/cron.d/bootstrap ]; then
    logger "[$$] [$0] exiting... already bootstrapped"
fi

logger "[$$] [$0] bootstrapping. Hang on..."

# Upgrade system to latest
logger "[$$] [$0] upgrade system"
apt-get update 
apt-get upgrade
logger "[$$] [$0] upgrade system complete"


# Install ruby+chef
logger "[$$] [$0] install ruby+chef"
apt-get install -y ruby ruby1.8-dev build-essential wget libruby1.8 rubygems
gem update --no-rdoc --no-ri
logger "[$$] [$0] ruby+chef installed"

# Set up berkshelf
logger "[$$] [$0] install bundler"
gem install bundler
logger "[$$] [$0] bundler installed"

# Install git
logger "[$$] [$0] install git"
apt-get install -y git
logger "[$$] [$0] git installed"

# Set up chef
logger "[$$] [$0] setting up chef"
mkdir /srv
cd /srv && git clone https://github.com/jessecollier/configs.git
cd /srv/configs && bundle install
cd /srv/configs && berks install
chef-solo -c /srv/configs/chef/config.rb
logger "[$$] [$0] chef complete"

logger "[$$] [$0] removing bootstrap"
rm /etc/cron.d/bootstrap