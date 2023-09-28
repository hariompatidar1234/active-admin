class Cart < ApplicationRecord
  belongs_to :customer, foreign_key: 'user_id'

  has_many :cart_items
  has_many :dishes, through: :cart_items

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "updated_at", "user_id"]
  end
end
