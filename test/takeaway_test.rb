require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'
require_relative '../lib/takeaway'

describe Takeaway do
  
  before do
    @takeaway = Takeaway.new
    @to = "+447970261478"
    @from = "+441290211259"
  end

  it "should send a text message" do
    message = "Hi, Just testing with an SMS message"
    @takeaway.messenger.expects(:create).with(to: @to, from: @from, body: message).returns(true).once
    @takeaway.send_text(@to, @from, message)
  end

  it "should be possible to add dishes to the menu" do
    @takeaway.add_to_menu('ham & pinapple pizza' => 1.00, 'cheese & tomato pizza' => 2.00)
  end

  it "should return a list of dishes with prices" do
    @takeaway.add_to_menu('ham & pinapple pizza' => 1.00, 'cheese & tomato pizza' => 2.00)
    expected_menu = {'ham & pinapple pizza' => 1.00, 'cheese & tomato pizza' => 2.00}
    @takeaway.menu.must_equal expected_menu
  end

  it "should be possible to remove dishes from the menu" do
    @takeaway.add_to_menu('ham & pinapple pizza' => 1.00, 'cheese & tomato pizza' => 2.00)
    @takeaway.remove_from_menu(['ham & pinapple pizza'])
    expected_menu = {'cheese & tomato pizza' => 2.00}
    @takeaway.menu.must_equal expected_menu
  end

  it "can receive an order" do
    @takeaway.add_to_menu('ham & pinapple pizza' => 1.00, 'cheese & tomato pizza' => 2.00, 'pepperoni' => 3.00)
    @takeaway.receive_order(:total_price => 5.00, 
                            :dishes =>  ['pepperoni',
                                        'cheese & tomato pizza']).must_equal 5.00
  end

  it "should.... " do
    # @takeaway.messenger.stubs(:create).returns(true)

  end







end