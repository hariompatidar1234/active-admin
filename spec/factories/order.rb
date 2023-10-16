FactoryBot.define do 
  factory :order do 
    user_id { FactoryBot.create(:user, type: "Customer").id }
  end 
end