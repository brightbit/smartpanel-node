trap("USR1") { puts 'Running...'; $stdout.flush }

lib = File.expand_path '../../lib', __FILE__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup'
require 'logger'
require 'json'
require 'smartpanel-node/dotenv'
require 'smartpanel-node/configuration'

module SmartpanelNode
  class << self
    attr_accessor :configuration

    def config
      self.configuration ||= Configuration.new
    end
  end
end

require 'inotify_proxy'
require 'smartpanel-node/breaker'
require 'smartpanel-node/breaker_shifter'
require 'smartpanel-node/breaker_states_poller'

shifter_thread = Thread.new { SmartpanelNode::BreakerShifter.new }
poller_thread = Thread.new { SmartpanelNode::BreakerPoller.new }

if ENV['DAEMONIZE'] == 'true'
  shifter_thread.join
  poller_thread.join
end
