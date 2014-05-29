module SmartpanelNode
  class Breaker
    attr_reader :breaker_states_filename, :id

    def initialize(id)
      @breaker_states_filename = SmartpanelNode.config.breaker_states_store
      @id = id

      ensure_breaker_states_file_exists
    end

    def flip
      self.state = flip_bit state
    end

    def on
      self.state = "1"
    end

    def off
      self.state = "0"
    end

    def on?
      state == "1"
    end

    def off?
      state == "0"
    end

    private
    def ensure_breaker_states_file_exists
      unless File.exists? breaker_states_filename
        File.write breaker_states_filename, "0" * SmartpanelNode.config.total_breakers
      end
    end

    def breaker_states_string
      read_breaker_states
    end

    def breaker_states_string=(value)
      write_breaker_states value
    end

    def read_breaker_states
      File.open(breaker_states_filename, 'rb'){|f| f.read }
    end

    def write_breaker_states(value)
      File.open(breaker_states_filename, 'w'){|f| f.write value }
    end

    def breaker_string_index
      SmartpanelNode.config.breaker_mappings[id]
    end

    def state
      breaker_states_string[breaker_string_index]
    end

    def state=(value)
      new_breaker_states_string = breaker_states_string
      new_breaker_states_string[breaker_string_index] = value.to_s
      self.breaker_states_string = new_breaker_states_string
    end

    def flip_bit(bit)
      bit == "0" ? "1" : "0"
    end
  end
end
