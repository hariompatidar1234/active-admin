FactoryBot.define do
  factory :restaurant do
    name          { Faker::Restaurant.name }
    address       { Faker::Address.city}
    status        {['open','closed'].sample}
    user_id { FactoryBot.create(:user, type: "Owner").id }
  end
end
