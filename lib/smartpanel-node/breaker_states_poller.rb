require 'json'
require 'typhoeus'

base_url = 'https://smartpanel-staging.herokuapp.com/api'
breakers = SmartpanelNode::Breaker::TOTAL_BREAKERS.times.map {|i| SmartpanelNode::Breaker.new i+1 }

loop do
  breakers.each do |breaker|
    begin
      #TODO: Read user:password from credentials.txt
      response = Typhoeus.get "#{base_url}/breakers/#{breaker.id}", userpwd: "user@example.com:password"
      json = JSON.parse response.body

      proposed_state = json['breaker']['circuit_closed']
      if (proposed_state == true && breaker.off?) || (proposed_state == false && breaker.on?)
        state_changed = true
        breaker.flip
      end

      if state_changed
        current_load = breaker.on? ? rand(0.1..20.00) : 0.0
        Typhoeus.post "#{base_url}/breaker_readings",
          body: {breaker_reading: { amperage: current_load, voltage: 120, breaker_id: breaker.id }},
          userpwd: "user@example.com:password"
      end

      response, json = nil, nil
    rescue
      nil #TODO Remove rescue nil for better error handling
    end
  end

  sleep 5
end

