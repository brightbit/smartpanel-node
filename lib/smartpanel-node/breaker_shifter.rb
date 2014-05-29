require 'pi_piper'
require 'rb-inotify'

module SmartpanelNode
  class BreakerShifter
    PINS = {
      data:  PiPiper::Pin.new(pin: SmartpanelNode.config.pins[:data],  direction: :out),
      clock: PiPiper::Pin.new(pin: SmartpanelNode.config.pins[:clock], direction: :out),
      latch: PiPiper::Pin.new(pin: SmartpanelNode.config.pins[:latch], direction: :out),
    }

    def initialize
      shift_state_filename = SmartpanelNode.config.breaker_states_store
      send_bits File.open(shift_state_filename, 'r'){|f| f.read }[22..-1]

      notifier = INotify::Notifier.new

      notifier.watch(shift_state_filename, :modify) do
        file = File.open(shift_state_filename, 'r'){|f| f.read }
        send_bits file[22..-1] unless file.empty?
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
        PINS[:data].on if data[byte] == "1"
        shift :clock
        PINS[:data].off
      end
      shift :latch
    end
  end
end
