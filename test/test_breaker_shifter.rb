require 'test_helper'

describe SmartpanelNode::BreakerShifter do
  def logger_messages
    @logger_io.string.strip.split "\n"
  end

  def clear_logger_messages
    @logger_io.string = String.new
  end

  def load_fixture(name)
    YAML.load_file SmartpanelNode.config.root + "test/fixtures/#{name}.yml"
  end

  before do
    MiniTest::Spec.delete_breaker_states_store
    @logger_io = StringIO.new
    @logger = Logger.new @logger_io
    @logger.formatter = ->(_,_,_,msg) { "#{msg}\n" }
    @driver = PiPiper::StubDriver.new logger: @logger
    PiPiper::Platform.driver = @driver
  end

  let(:shifter) { SmartpanelNode::BreakerShifter.new }
  let(:breaker_1) { SmartpanelNode::Breaker.new 1 }
  let(:breaker_2) { SmartpanelNode::Breaker.new 2 }

  it "turns breakers on and off" do
    shifter # Get let off its lazy loading butt
    logger_messages.must_equal load_fixture('breaker_shifter_0000_0000_0000_0000')
    clear_logger_messages

    breaker_1.on
    shifter.process
    logger_messages.must_equal load_fixture('breaker_shifter_1000_0000_0000_0000')
    clear_logger_messages

    breaker_1.off
    shifter.process
    logger_messages.must_equal load_fixture('breaker_shifter_0000_0000_0000_0000')
    clear_logger_messages

    breaker_2.on
    shifter.process
    logger_messages.must_equal load_fixture('breaker_shifter_0100_0000_0000_0000')
    clear_logger_messages

    breaker_2.off
    shifter.process
    logger_messages.must_equal load_fixture('breaker_shifter_0000_0000_0000_0000')
    clear_logger_messages
  end
end
