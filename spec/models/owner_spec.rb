require 'rails_helper'
# require 'rspec/rails'
# require 'shoulda/matchers'

RSpec.describe Owner, type: :model do
  it "has many restaurants" do
    should have_many(:restaurants).with_foreign_key('user_id').dependent(:destroy)
  end
end