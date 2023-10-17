FactoryBot.define do
  factory :cart_item do
    total_amounts { 100 }
    quantity { 5 }
    cart { association :cart }
    dish { association :dish}
  end
end
