require 'rails_helper'
include JsonWebToken
RSpec.describe DishesController, type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category) }
  let!(:restaurant) { FactoryBot.create(:restaurant, user_id: user.id) }
  let!(:dish) { FactoryBot.create(:dish, restaurant: restaurant, category: category) }
  let!(:valid_jwt) { jwt_encode(user_id: user.id) }


  describe 'POST /dishes' do
    it 'creates a dish for owners' do
      owner = FactoryBot.create(:user, type: 'Owner')
      category = FactoryBot.create(:category)
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      post '/dishes',
           params: { name: 'Jeera Rice', price: 100, restaurant_id: restaurant.id, category_id: category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:created)
    end
    it 'returns an error for customers trying to create a dish' do
      owner = FactoryBot.create(:user, type: 'Owner')
      owner1 = FactoryBot.create(:user, type: 'Owner')
      category = FactoryBot.create(:category)
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      post '/dishes',
           params: { name: 'Dish Name', price: 9.99, restaurant_id: restaurant.id, category_id: category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner1.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it 'returns an error for invalid dish creation' do
      owner = FactoryBot.create(:user, type: 'Owner')
      category = FactoryBot.create(:category)
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      post '/dishes', params: { name: nil, price: nil, restaurant_id: restaurant.id, category_id: category.id },
                      headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  describe 'GET /dishes/:id' do
    it 'shows a dish ' do
      get "/dishes/#{dish.id}", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
