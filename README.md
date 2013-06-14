This repo contains my response to task **2** of a coding challenge set in 2013 by Evgeny Shadchnev at Makers Academy in London.

Task 2 Details
--------------

Feel free to use google, your notes, books, etc but work on your own.

  *  Write a class Takeaway.
  *  Implement the following functionality:
    - list of dishes with prices
    - place the order by giving the list of dishes, their quantities and a number that should be an exact total. If the sum is not correct the method should raise an error, otherwise the customer is sent a text saying that the order was placed successfully and that it will be delivered 1 hour from now (e.g. "Thank you! Your order was placed and will be delivered before 18:52".)
    - The test sending functionality should be implemented using Twilio API. You'll need to register for it.
    - Use twilio-ruby gem to access the API
    - Use a Gemfile to manage your gems
    - Make sure that your Takeaway class is thoroughly thested and that you use mocks and/or stubs, as necessary to not send texts when your tests are run.
    - If your Takeaway class were to be loaded into IRB and the order was placed, the test should actually be sent
  *  A free account on Twilio will only allow you to send tests to "verified" numbers. Use your own mobile phone number, don't worry about the customer's mobile phone.

