FactoryBot.define do
  factory :owner do
  name          { Faker::Name.name }
  email         { Faker::Internet.email}
  password      { Faker::Internet.password(min_length: 8)}
  end
end
