require 'rails_helper'
# require 'rspec/rails'
# require 'shoulda/matchers'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "validates presence of name" do
      user = User.new(name: 'hariom')
      expect(user).to validate_presence_of(:name)
    end

    it "validates presence of email" do
      user = User.new(email: 'hariom123@gmail.com')
      expect(user).to validate_presence_of(:email)
    end

    it "validates presence of password" do
      user = User.new(password: '123456')
      expect(user).to validate_presence_of(:password)
    end

    it "validates uniqueness of email" do
      existing_user = create(:user, email: 'existing_email@example.com')
      user = build(:user, email: 'existing_email@example.com')
      expect(user).to validate_uniqueness_of(:email)
    end
  end

  describe "Inclusion" do
    it "validates inclusion of type" do
      expect(subject).to validate_inclusion_of(:type).in_array(['Customer', 'Owner'])
    end
  end

  it "has one attached image" do
    expect(subject).to have_one_attached(:image)
  end
end
