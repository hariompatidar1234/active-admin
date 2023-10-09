class Restaurant < ApplicationRecord
  belongs_to :owner, foreign_key: 'user_id'
  has_many :dishes, dependent: :destroy

  has_one_attached :image

 validates :status, inclusion: { in: %w[open closed] }

  validates :name, :status, :address, presence: true
  validates :name, uniqueness: { scope: :address }

  # def self.ransackable_attributes(_auth_object = nil)
  #   ['address', 'created_at', 'id', 'name', 'status', 'image' 'updated_at', 'user_id']
  # end
end
