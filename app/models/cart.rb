class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	has_many :payment_notifications
	def add_product(product_id)
		current_item = line_items.find_by(product_id: product_id)
		if current_item
			current_item.quantity += 1
		else
		current_item = line_items.build(product_id: product_id)
		end
		current_item
	end

	public 
	def total
		line_items.to_a.sum{|item| item.total_price}		
	end

	def paypal_url(return_url, notify_url)
		values={
			:business => 'new.mingliang@gmail.com',
			:cmd => '_cart',
			:upload => 1,
			:return => return_url,
			:invoice => id,
			:notify_url => notify_url
		}
		line_items.each_with_index do |item, index|
			values.merge!({
				"amount_#{index+1}" => item.product.price,
				"item_name_#{index+1}" => item.product.title,
				"item_number_#{index+1}" => item.id,
				"quantity_#{index+1}" => item.quantity
				})
		end
		"https://www.sandbox.paypal.com/cgi-bin/webscr?"+values.map {|k,v| "#{k} = #{v}"}.join("&")
		
	end

	
end
