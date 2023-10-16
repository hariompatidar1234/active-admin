FactoryBot.define do 
  factory :orderitem do 
    price { 100 }
    quantity { 5 }
    order { FactoryBot.create(:cart) }
    dish { FactoryBot.create(:dish) }
  end   
end