FactoryBot.define do
  factory :order do
    address       { Faker::Address.city}
    user_id { FactoryBot.create(:user, type: "Customer").id }
  end
end
