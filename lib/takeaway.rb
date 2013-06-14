# twilio-number: +441290211259
require 'bundler/setup'
require 'twilio-ruby'

class Takeaway
attr_reader :messenger
attr_reader :menu

ACCOUNT_SID = 'AC72f58d844bc5b1a82a02fe1dad6bad71'
AUTH_TOKEN = '120034c38f454a4f73029e420c43e8bd'


def initialize()
  @menu = {}
  @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
  @messenger = @client.account.sms.messages
end

def add_to_menu(menu_items={})
  @menu.merge!(menu_items)
end

def remove_from_menu(menu_items=[])
  menu_items.each {|item| @menu.delete(item) }
end

def receive_order(order)
  total_price = order[:total_price] || 0.00
  dishes      = order[:dishes]      || []
  total_price
end

def send_text(to, from, message_body)
  message = @messenger.create(
    :body => message_body,
    :to => to,
    :from => from)
end

end