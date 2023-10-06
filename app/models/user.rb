class User < ApplicationRecord
  validates :type, inclusion: { in: %w[Owner Customer] }
  validates :name, :email, :password, presence: true
  validates :email, uniqueness: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'Invalid email id!!!!' }

  has_one_attached :image

  def self.ransackable_attributes(_auth_object = nil)
    ['created_at', 'email', 'id', 'name', 'password', 'image' 'reset_password_sent_at', 'reset_password_token', 'type',
     'updated_at']
  end
end
