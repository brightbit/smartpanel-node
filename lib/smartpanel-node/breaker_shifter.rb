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

    attr_accessor :shift_state_filename
    def initialize
      @shift_state_filename = SmartpanelNode.config.breaker_states_store
      ensure_shift_state_file_exists
      process
    end

    def process
      send_bits bit_string
    end

    def run
      notifier = InotifyProxy.new shift_state_filename.dirname.to_s
      notifier.watch -> { process }
      notifier.run
    end

    def send_bits(data)
      reset_shift_pins
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

    private
    def ensure_shift_state_file_exists
      unless File.exists? shift_state_filename
        string = "export BREAKER_STATES=" + "0" * SmartpanelNode.config.total_breakers
        File.write shift_state_filename, string
      end
    end

    def bit_string
      File.open(shift_state_filename, 'r'){|f| f.read }.to_s[22..-1]
    end

    def shift(key)
      PINS[key].on
      PINS[key].off
    end

    def reset_shift_pins
      PINS.values.each{|pin| pin.off }
    end
  end
end
