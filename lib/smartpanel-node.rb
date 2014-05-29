lib = File.expand_path '../../lib', __FILE__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'bundler/setup'
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

require 'smartpanel-node/breaker'
require 'smartpanel-node/breaker_shifter'
require 'smartpanel-node/breaker_states_poller'

Thread.new { SmartpanelNode::BreakerShifter.new }.join
Thread.new { SmartpanelNode::BreakerPoller }.join
