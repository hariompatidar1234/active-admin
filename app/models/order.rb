class Order < ApplicationRecord
  belongs_to :customer, foreign_key: 'user_id'

  has_many :order_items, dependent: :destroy
  has_many :dishes, through: :order_items
  validates :address, presence: true


  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "id", "updated_at", "user_id"]
  end
end
