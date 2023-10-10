class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :dish

  before_save :total_amount

  private

  def total_amount
    dish_total_amounts = quantity * dish.price
    self.total_amounts = dish_total_amounts
  end

  # def self.ransackable_attributes(_auth_object = nil)
  #   %w[cart_id created_at dish_id id quantity total_amounts updated_at]
  # end
end
