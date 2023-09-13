class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :dish

  # before_save :calculate_total_amount
  # private
  # def calculate_total_amount
  #   self.total_amounts = cart_items.includes(:dish).sum { |cart_item| cart_item.dish.price * cart_item.quantity }
  # end
  def total_price
 product_items.to_a.sum{|item| item.total_price}
end
end
