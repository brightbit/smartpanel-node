ENV['DAEMONIZE'] = 'false'
ENV['RACK_ENV'] = 'test'
ENV['API_ENDPOINT'] =' http://example.com/api'
ENV['BREAKER_STATES_STORE'] = 'tmp/states.env.test'

class MiniTest::Spec
  class << self
    def delete_breaker_states_store
      app_root = Pathname.new(File.expand_path('../..', __FILE__))
      ENV['BREAKER_STATES_STORE_FULL'] = (app_root + ENV['BREAKER_STATES_STORE']).to_s
      File.delete ENV['BREAKER_STATES_STORE_FULL'] rescue nil
    end
  end
end

MiniTest::Spec.delete_breaker_states_store

require 'pry-rescue/minitest'
require 'smartpanel-node'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
