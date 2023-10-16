FactoryBot.define do
    factory :dish do
      name { Faker::Food.dish }  # You can use the Faker gem for sample dish names
      price {70}
      category { association :category }  # Assuming you have a Category factory
      restaurant { association :restaurant, :with_owner }
    end
  end
  