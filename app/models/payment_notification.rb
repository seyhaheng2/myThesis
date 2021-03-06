class PaymentNotification < ActiveRecord::Base
  belongs_to :cart
  belongs_to :order
  serialize :params
  after_create :mark_cart_as_purchased
  
private
  def mark_cart_as_purchased
    	if status == "Completed"
      	cart.update_attributes(:purchased_at => Time.now)
      	order= Order.last
      	order.update_attributes(:purchased_at => Time.now)
  	end
   end
end
