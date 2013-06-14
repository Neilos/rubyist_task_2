require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'
require_relative '../lib/takeaway'

describe Takeaway do
  
  before do
    @takeaway = Takeaway.new("+441290211259", 'meat feast pizza' => 2.00)
    @customer_tel = "+447970261478"
    @from = "+441290211259"
  end

  it "should return a list of dishes with prices" do
    expected_menu = {'meat feast pizza' => 2.00}
    @takeaway.menu.must_equal expected_menu
  end

  it "should be possible to add dishes to the menu" do
    @takeaway.add_to_menu(
      'ham & pinapple pizza' => 1.00,
      'cheese & tomato pizza' => 2.00)
    expected_menu = {
      'meat feast pizza' => 2.00,
      'ham & pinapple pizza' => 1.00,
      'cheese & tomato pizza' => 2.00}
    @takeaway.menu.must_equal expected_menu
  end

  it "should be possible to remove dishes from the menu" do
    @takeaway.remove_from_menu(["meat feast pizza"])
    expected_menu = {}
    @takeaway.menu.must_equal expected_menu
  end

  it "can process an order" do
    @takeaway.stubs(:send_text).returns(true)
    @takeaway.add_to_menu(
      'ham & pinapple pizza' => 1.00,
      'cheese & tomato pizza' => 2.00,
      'pepperoni' => 3.00)
    @takeaway.process_order(
      :expected_value => 5.00, 
      :telephone_number => @customer_tel,
      :dishes =>  ['pepperoni', 'cheese & tomato pizza'])
  end

  it "can calculate the value of dishes" do
    @takeaway.add_to_menu(
      'ham & pinapple pizza' => 1.00,
      'cheese & tomato pizza' => 2.00,
      'pepperoni' => 3.00)
    dishes = ['ham & pinapple pizza', 'cheese & tomato pizza', 'pepperoni']
    @takeaway.send(:value_of, dishes)
  end

  it "should reject orders when the prices of dishes don't sum to equal the given total_prices" do
    @takeaway.stubs(:send_text).returns(true)
    @takeaway.add_to_menu(
      'ham & pinapple pizza' => 1.00,
      'cheese & tomato pizza' => 2.00,
      'pepperoni' => 3.00)
    lambda { @takeaway.process_order(
              :expected_value => 5.00,
              :dishes =>  ['pepperoni'], 
              :telephone_number => @customer_tel) 
    }.must_raise RuntimeError, "Please confirm your order."
  end

  it "should generate an appropriate confirmation message" do
    expected_message = (Time.now + 3600).strftime("Thank you. Your order has been placed and will be delivered before %H:%M")
    @takeaway.send(:confirmation_message).must_equal expected_message
  end

  it "should be able to send a text message" do
    message = "Hi, Just testing with an SMS message"
    @takeaway.messenger.expects(:create).with(to: @to, from: @from, body: message).returns(true).once
    @takeaway.send(:send_text, @to, @from, message)
  end

  it "should send a text message confirmation if a valid order is processed" do
    @takeaway.add_to_menu('ham & pinapple pizza' => 1.00, 'cheese & tomato pizza' => 2.00, 'pepperoni' => 3.00)
    expected_message = (Time.now + 3600).strftime("Thank you. Your order has been placed and will be delivered before %H:%M")
    @takeaway.stubs(:send_text).returns(true)
    @takeaway.process_order(
      :expected_value => 5.00,
      :dishes =>  ['pepperoni','cheese & tomato pizza'],
      :telephone_number => @customer_tel)
  end


end