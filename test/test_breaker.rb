require 'test_helper'

describe SmartpanelNode::Breaker do
  def states_store
    File.read(ENV['BREAKER_STATES_STORE_FULL']).to_s[22..-1]
  end

  before do
    MiniTest::Spec.delete_breaker_states_store
  end

  let(:breaker_1) { SmartpanelNode::Breaker.new 1 }
  let(:breaker_2) { SmartpanelNode::Breaker.new 2 }

  it "turns breaker_1 on and off" do
    breaker_1.off?.must_equal true
    breaker_1.on?.must_equal false
    states_store.must_equal "0" * 16

    breaker_1.on
    breaker_1.off?.must_equal false
    breaker_1.on?.must_equal true
    states_store.must_equal "1" + "0" * 15

    breaker_1.off
    breaker_1.off?.must_equal true
    breaker_1.on?.must_equal false
    states_store.must_equal "0" * 16
  end

  it "turns breaker_2 on and off" do
    breaker_2.off?.must_equal true
    breaker_2.on?.must_equal false
    states_store.must_equal "0" * 16

    breaker_2.on
    breaker_2.off?.must_equal false
    breaker_2.on?.must_equal true
    states_store.must_equal "01" + "0" * 14

    breaker_2.off
    breaker_2.off?.must_equal true
    breaker_2.on?.must_equal false
    states_store.must_equal "0" * 16
  end

  it "inverts a breaker state (flip)" do
    breaker_2.off?.must_equal true
    breaker_2.on?.must_equal false
    states_store.must_equal "0" * 16

    breaker_2.flip
    breaker_2.off?.must_equal false
    breaker_2.on?.must_equal true
    states_store.must_equal "01" + "0" * 14

    breaker_2.flip
    breaker_2.off?.must_equal true
    breaker_2.on?.must_equal false
    states_store.must_equal "0" * 16
  end

  it "won't instatiate a breaker outside the breaker mappings" do
    error = -> { SmartpanelNode::Breaker.new(100) }.must_raise RuntimeError
    error.message.must_equal 'Invalid Breaker ID: 100'
  end
end
