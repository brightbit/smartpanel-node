module SmartpanelNode
  class Breaker
    attr_reader :total_breakers, :breakers_mappings, :breakers_states_filename, :id

    #TODO: Read breaker mappings from breaker_mappings.json
    BREAKERS_MAPPINGS = {  1 => 0 ,  2 =>  1 }
    #BREAKERS_MAPPINGS = {  1 => 0 ,  2 =>  1,  3 =>  2,  4 =>  3,  5 =>  4,  6 =>  5,  7 =>  6,  8 =>  7,  9 =>  8,
    #                      10 => 9 , 11 => 10, 12 => 11, 13 => 12, 14 => 13, 15 => 14, 16 => 15 }
    TOTAL_BREAKERS = BREAKERS_MAPPINGS.count

    def initialize(id)
      @breakers_mappings = BREAKERS_MAPPINGS
      @total_breakers = TOTAL_BREAKERS
      @breakers_states_filename = '/etc/smartpanel/breakers_states.txt'
      @id = id

      ensure_breakers_states_file_exists
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
    def ensure_breakers_states_file_exists
      unless File.exists? breakers_states_filename
        File.write breakers_states_filename, "0" * total_breakers
      end
    end

    def breakers_states_string
      read_breakers_states
    end

    def breakers_states_string=(value)
      write_breakers_states value
    end

    def read_breakers_states
      File.open(breakers_states_filename, 'rb'){|f| f.read }
    end

    def write_breakers_states(value)
      File.open(breakers_states_filename, 'w'){|f| f.write value }
    end

    def breaker_string_index
      breakers_mappings[id]
    end

    def state
      breakers_states_string[breaker_string_index]
    end

    def state=(value)
      new_breakers_states_string = breakers_states_string
      new_breakers_states_string[breaker_string_index] = value.to_s
      self.breakers_states_string = new_breakers_states_string
    end

    def flip_bit(bit)
      bit == "0" ? "1" : "0"
    end
  end
end
