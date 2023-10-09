require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should have_many(:dishes).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name)}
end
