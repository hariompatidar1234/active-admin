FactoryBot.define do 
   factory :cart do 
    user_id { FactoryBot.create(:user, type: "Customer").id }
   end 
end 