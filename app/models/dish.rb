class Dish < ApplicationRecord
  belongs_to :category
  belongs_to :restaurant

  has_many :cart_items, dependent: :destroy
  has_many :cart, through: :cart_items

  has_many :order_items, dependent: :nullify
  has_many :orders, through: :order_items

  has_one_attached :image

  validates :name, :price,  presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :restaurant_id, uniqueness: { scope: :name, message: 'dish already added ' }

  # def self.ransackable_attributes(_auth_object = nil)
  #   %w[category_id created_at id name price image restaurant_id updated_at]
  # end
end
