class User < ApplicationRecord
  validates :name, :email, :password, presence: true
  validates :email, uniqueness: true
  validates :type, inclusion: { in: %w[Owner Customer] }

  has_one_attached :image

  # def self.ransackable_attributes(_auth_object = nil)
  #   ['created_at', 'email', 'id', 'name', 'password', 'image' 'reset_password_sent_at', 'reset_password_token', 'type',
  #    'updated_at']
  # end
end
