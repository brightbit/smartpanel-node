module SmartpanelNode
  class Configuration
    attr_accessor :username, :auth_token, :pins, :breaker_states_store,
      :breaker_mappings, :total_breakers, :breaker_states, :api_endpoint, :root

    def initialize
      @root = Pathname.new File.expand_path('../../..', __FILE__)
      @api_endpoint = ENV.fetch('API_ENDPOINT')
      @username     = ENV['API_USERNAME']
      @auth_token   = ENV['API_AUTH_TOKEN']

      @pins = {
        data:  ENV.fetch('PIN_DATA'),
        clock: ENV.fetch('PIN_CLOCK'),
        latch: ENV.fetch('PIN_LATCH'),
      }

      @breaker_states_store = @root + ENV.fetch('BREAKER_STATES_STORE')

      @breaker_mappings = JSON.parse ENV.fetch('BREAKER_MAPPINGS')
      @breaker_states = ENV.fetch('BREAKER_STATES')
      @total_breakers = @breaker_mappings.count
    end
  end
end
