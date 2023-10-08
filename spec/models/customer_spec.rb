# spec/models/customer_spec.rb

require 'rails_helper'
# require 'rspec/rails'
# require 'shoulda/matchers'

RSpec.describe Customer, type: :model do
  it "has one cart" do
    should have_one(:cart).with_foreign_key('user_id').dependent(:destroy)
  end

  it "has many orders" do
    should have_many(:orders).with_foreign_key('user_id').dependent(:destroy)
  end
end
