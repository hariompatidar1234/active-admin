FactoryBot.define do
  factory :restaurant do
    name          { Faker::Restaurant.name }
    address       { Faker::Address.city}
    status        {['open','closed'].sample}
    association :user , factory: :user,type: 'Owner'
  end
end
