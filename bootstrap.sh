#!/usr/bin/env bash

# Exit on any error
set -e

# Update system
apt-get -y update
apt-get -y upgrade

# Install system packages (ruby-dev for pi_piper)
apt-get install ruby-dev

# Install bundler (used in smartpanel-node software)
gem install bundler --no-ri --no-rdoc

# Checkout this repository (wow! so meta)
git clone https://github.com/brightbit/smartpanel-node /etc/smartpanel

# Install bundle files
cd /etc/smartpanel
bundle install --path vendor/bundle --binstubs vendor/bundle/bin
