# twilio-number: +441290211259
require 'bundler/setup'
require 'twilio-ruby'

class Takeaway
  attr_reader :messenger
  attr_reader :menu, :phone_number

  ACCOUNT_SID = 'AC72f58d844bc5b1a82a02fe1dad6bad71'
  AUTH_TOKEN = '120034c38f454a4f73029e420c43e8bd'

  def initialize(phone_number, menu={})
    @menu = menu # an array of dish names and prices, e.g. {dish1 => 1.00, dish2 => 2.00}
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
    @messenger = @client.account.sms.messages
    @phone_number = phone_number
  end

  # menu_items should be a hash
  # {dish1 => 1.00, dish2 => 2.00}
  # where the dish names are the keys
  # and the prices are the values
  def add_to_menu(menu_items={})
    menu.merge!(menu_items)
  end

  # dish_names is an array of dish names 
  # to be removed from the menu. 
  def remove_from_menu(dish_names=[])
    dish_names.each {|item| @menu.delete(item) }
  end

  # orders are given as a hash with three keys
  # :expected_value => 5.00, 
  # :telephone_number => "09898080980980",
  # :dishes =>  {'pepperoni' => 1,
  #              'cheese & tomato pizza' =>2]
  # the values in the dishes hash are quantities to be ordered
  def process_order(order={})
    expected_value  = order[:expected_value] || 0.00
    dishes          = order[:dishes]         || []
    customer_tel    = order[:telephone_number]
    raise "Please confirm your order. Total value is not what you expected." unless expected_value == value_of(dishes)
    send_text(customer_tel, phone_number, confirmation_message) if customer_tel
  end

private

  # dishes argument must be a hash of dish names and quantities
  # e.g. {'dish1' => 2} means two of 'dish1'
  # dish names should match dishes in the menu
  def value_of(dishes=[])
    dishes.inject(0) do |sum, (dish, quantity)| 
      raise "Sorry. We don't serve #{dish}" unless menu[dish]
      sum + menu[dish] * quantity
    end
  end

  def confirmation_message
    (Time.now + 3600).strftime("Thank you. Your order has been placed and will be delivered before %H:%M")
  end

  # sends an SMS text message
  def send_text(to, from, message_body)
    message = @messenger.create(
      :body => message_body,
      :to => to,
      :from => from)
  end

end