lib = File.expand_path '../../lib', __FILE__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

#require 'bundler/setup'
require 'smartpanel-node/breaker'
require 'smartpanel-node/breaker_states_poller'

