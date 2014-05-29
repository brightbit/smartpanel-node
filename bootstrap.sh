#!/usr/bin/env bash
apt-get -y update
apt-get -y upgrade
apt-get install ruby-dev

gem install bundler --no-ri --no-rdoc
