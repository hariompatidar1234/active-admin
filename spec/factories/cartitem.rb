FactoryBot.define do 
    factory :cartitem do 
        price { 100 }
        quantity { 5 }
        cart { FactoryBot.create(:cart) }
        dish { FactoryBot.create(:dish) }
    end 
end