require 'rails_helper'
require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe "assocaition" do
    it { should have_many(:order_items).dependent(:nullify) }
    it { should have_many(:cart_items).dependent(:destroy)}
    it { should have_many(:orders).through(:order_items)}
    it { should have_one_attached(:image)}
    it { should belong_to(:category)}
    it { should belong_to(:restaurant)}
  end

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    # it { should validate_uniqueness_of(:restaurant_id).scoped_to(:name) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end
end
