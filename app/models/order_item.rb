class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :dish

  # def self.ransackable_attributes(_auth_object = nil)
  #   %w[created_at dish_id id order_id quantity total_amount updated_at]
  # end
end
