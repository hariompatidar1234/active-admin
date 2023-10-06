  require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "VALIODATION" do
   subject { User.new(name: 'hariom') }
   subject { User.new(status: 'Customer') }
   subject { User.new(email: 'hariom123@gmail.com') }
   subject { User.new(password: '123456') }

   it { should validate_presence_of(:password) }
   it { should validate_presence_of(:name) }
   it { should validate_presence_of(:email) }
   it { should validate_uniqueness_of(:email)

  end

  describe "INCLUSION" do
    it do
      should validate_inclusion_of(:type).
        in_array(['Customer', 'Owner'])
    end
  end

  it { should have_one_attached(:image) }

end
