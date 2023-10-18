FactoryBot.define do
  factory :order_item do
    total_amount { 100 }
    quantity { 5 }
    order { association :order }
    dish { association :dish}
  end
end
