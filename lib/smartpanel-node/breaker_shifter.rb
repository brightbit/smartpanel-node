require 'pi_piper'

unless SmartpanelNode.production?
  PiPiper::Platform.driver = PiPiper::StubDriver.new#(logger: Logger.new($stdout))
end

module SmartpanelNode
  class BreakerShifter
    PINS = {
      data:  PiPiper::Pin.new(pin: SmartpanelNode.config.pins[:data],  direction: :out),
      clock: PiPiper::Pin.new(pin: SmartpanelNode.config.pins[:clock], direction: :out),
      latch: PiPiper::Pin.new(pin: SmartpanelNode.config.pins[:latch], direction: :out),
    }

    def initialize
      shift_state_filename = SmartpanelNode.config.breaker_states_store
      send_bits File.open(shift_state_filename, 'r'){|f| f.read }.to_s[22..-1]

      notifier = InotifyProxy.new shift_state_filename.dirname.to_s

      notifier.watch -> do
        file = File.open(shift_state_filename, 'r'){|f| f.read }
        send_bits file.to_s[22..-1] unless file.empty?
      end

      notifier.run
    end

    private
    def shift(key)
      PINS[key].on
      PINS[key].off
    end

    def reset
      PINS.values.each{|pin| pin.off }
    end

    def send_bits(data)
      reset
      SmartpanelNode.config.total_breakers.times do |byte|
        if SmartpanelNode.development?
          puts "Breaker Pin #{byte} #{data[byte] == "1" ? "on" : "off"}"
        end

        PINS[:data].on if data[byte] == "1"
        shift :clock
        PINS[:data].off
      end
      shift :latch
    end
  end
end
