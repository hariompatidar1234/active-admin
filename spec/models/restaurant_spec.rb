require 'rails_helper'

RSpec.describe Restaurant, type: :model do

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:address) }
    it { should validate_inclusion_of(:status).in_array(['open', 'closed'])}

  end
  describe "association" do
     it { should have_many(:dishes).dependent(:destroy) }
     it { should belong_to(:owner).with_foreign_key('user_id')}
     it { should have_one_attached(:image)}
  end
   # it { should validate_uniqueness_of(:name).scoped_to(:address) }
end
