# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class EmailWhenShippedExtension < Spree::Extension
  version "1.0"
  description "Sends an email when an order transitions to shipped
  Licensed under the LGPL v2.1, see LICENSE for full details text.
  Copyright Adrian Tesson Associates 2010"
  url "http://www.tesson.co.uk/"

  def activate

    Order.class_eval do
      state_machine do
        after_transition :to => 'shipped', :do => :send_shipped_email
      end

      def send_shipped_email
        OrderMailer.deliver_shipped(self)
      end
    end

    OrderMailer.class_eval do
      def shipped(order)
        @subject    = "#{Spree::Config[:site_name]} Order Shipped ##{order.number}"
        @body       = {"order" => order}
        @recipients = order.email
        @from       = Spree::Config[:order_from]
        @bcc        = order_bcc
        @sent_on    = Time.now
      end
    end

  end
end
