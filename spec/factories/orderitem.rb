FactoryBot.define do
  factory :orderitem do
    total_amount { 100 }
    quantity { 5 }
    order { FactoryBot.create(:order) }
    dish { FactoryBot.create(:dish) }
  end
end
