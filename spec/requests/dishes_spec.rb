require 'rails_helper'
include JsonWebToken
RSpec.describe DishesController, type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category) }
  let!(:restaurant) { FactoryBot.create(:restaurant) }
  let!(:dish) { FactoryBot.create(:dish, restaurant: restaurant, category: category) }
  let!(:valid_jwt) { jwt_encode(user_id: user.id) }

  describe 'GET /dishes' do
    it "returns a JSON response with filtered dishes for a restaurant" do
      get "/dishes?restaurant_id=2", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns dishes filtered by category_id' do
      get "/dishes?category_id=2", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns dishes filtered by name' do
      get "/dishes?name=panner", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'paginates dishes' do
      get '/dishes?page=2', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /dishes' do
    it 'creates a dish for owners' do
      owner = FactoryBot.create(:user, type: 'Owner')
      category = FactoryBot.create(:category)
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      post '/dishes', params: { name: 'Jeera Rice', price: 100, restaurant_id: restaurant.id, category_id: category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:created)
    end
    it 'returns an error for customers trying to create a dish' do
      owner = FactoryBot.create(:user, type: 'Owner')
      owner1 = FactoryBot.create(:user, type: 'Owner')
      category = FactoryBot.create(:category)
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      post '/dishes', params: { name: 'Dish Name', price: 9.99, restaurant_id: restaurant.id,category_id: category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner1.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it 'returns an error for invalid dish creation' do
      owner = FactoryBot.create(:user, type: 'Owner')
      category = FactoryBot.create(:category)
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      post '/dishes', params: { name:nil, price: nil , restaurant_id: restaurant.id, category_id: category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /dishes/:id' do
    let(:valid_jwt) { jwt_encode(user_id: user.id) }
    let(:user) { FactoryBot.create(:user,type: "Owner") }
    let(:category) { FactoryBot.create(:category) }
    let(:restaurant) { FactoryBot.create(:restaurant, user_id: user.id) }
    let(:dish) { FactoryBot.create(:dish, restaurant: restaurant, category: category) }
    it 'shows a dish ' do
      get "/dishes/#{dish.id}", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /dishes/:id' do
    let(:owner) { FactoryBot.create(:user, type: 'Owner') }
    let(:category) { FactoryBot.create(:category) }
    let(:restaurant) { FactoryBot.create(:restaurant, user_id: owner.id) }
    let(:dish) { FactoryBot.create(:dish, restaurant: restaurant, category: category) }
    it 'updates a dish for owners' do
      put "/dishes/#{dish.id}", params: { name: 'Kachori' }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for invalid dish update' do
      put "/dishes/#{dish.id}", params: { name: nil }, headers: { 'Authorization' =>"Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'returns an error for owners updating a non-existent dish' do
      put '/dishes/non_existent_dish', params: { name: 'Updated Dish Name' }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:not_found)
    end
    it 'returns an error for customers trying to update a dish' do
      owner = FactoryBot.create(:user, type: 'Owner')
      owner1 = FactoryBot.create(:user, type: 'Owner')
      category = FactoryBot.create(:category)
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      post '/dishes', params: { name: 'Dish Name', price: 9.99, restaurant_id: restaurant.id,category_id: category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner1.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /dishes/:id' do
    let(:valid_jwt_owner) { jwt_encode(user_id: owner.id) }
    let(:owner) { FactoryBot.create(:user, type: 'Owner') }
    let(:category) { FactoryBot.create(:category) }
    let(:restaurant) { FactoryBot.create(:restaurant, user_id: owner.id) }
    let(:dish) { FactoryBot.create(:dish, restaurant: restaurant, category: category) }
    it 'deletes a dish for owners' do
      delete "/dishes/#{dish.id}", headers: { 'Authorization' => "Bearer #{valid_jwt_owner}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for customers trying to delete a dish' do
     owner = FactoryBot.create(:user, type: 'Owner')
      owner1 = FactoryBot.create(:user, type: 'Owner')
      category = FactoryBot.create(:category)
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      post '/dishes', params: { name: 'Dish Name', price: 9.99, restaurant_id: restaurant.id,category_id: category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner1.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it 'returns an error for owners trying to delete a non-existent dish' do
      delete '/dishes/non_existent_dish', headers: { 'Authorization' => "Bearer #{valid_jwt_owner}" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /dishes/owner_dishes" do
    it "show owner dishes filter with dishe name " do
     owner = FactoryBot.create(:user, type: 'Owner')
     restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
     FactoryBot.create(:dish,restaurant: restaurant)
      get '/dishes/owner_dishes', params: { name: 'panner' }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id) }" }
      expect(response).to have_http_status(:ok)
    end
     it "show owner dishes filter with category id " do
       owner = FactoryBot.create(:user, type: 'Owner')
      category = FactoryBot.create(:category)
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      dish = FactoryBot.create(:dish, restaurant: restaurant, category: category)
      get '/dishes/owner_dishes', params: {category_id: 1}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id) }" }
      expect(response).to have_http_status(:ok)
     end
  end
end
