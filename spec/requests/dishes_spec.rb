require 'rails_helper'
include JsonWebToken
RSpec.describe DishesController, type: :request do
  before   do
    @owner = FactoryBot.create(:user, type: 'Owner')
    @owner1 = FactoryBot.create(:user, type: 'Owner')
    @user = FactoryBot.create(:user)
    @restaurant = FactoryBot.create(:restaurant, user_id: @owner.id)
    @category = FactoryBot.create(:category)
    @dish = FactoryBot.create(:dish, restaurant_id: @restaurant.id, category_id: @category.id)
  end

  describe 'GET /dishes' do
    it 'returns with filtered dishes for a restaurant' do
      get '/dishes?restaurant_id=2', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns dishes filtered by category_id' do
      get '/dishes?category_id=2', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns dishes filtered by name' do
      get '/dishes?name=panner', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it 'paginates dishes' do
      get '/dishes?page=2', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /dishes' do
    it 'creates a dish for owners' do
      post '/dishes',
           params: { name: 'Jeera Rice', price: 100, restaurant_id: @restaurant.id, category_id: @category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner.id)}" }
      expect(response).to have_http_status(:created)
    end
    it 'returns an error for other owner trying to create a dish' do
      post '/dishes',
           params: { name: 'Dish Name', price: 9.99, restaurant_id: @restaurant.id, category_id: @category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner1.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it 'returns an error for invalid dish creation' do
      post '/dishes', params: { name: nil, price: nil, restaurant_id: @restaurant.id, category_id: @category.id },
                      headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /dishes/:id' do
    it 'shows a dish ' do
      get "/dishes/#{@dish.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /dishes/:id' do
    it 'updates a dish for owners' do
      put "/dishes/#{@dish.id}", params: { name: 'Kachori' },
                                 headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for invalid dish update' do
      put "/dishes/#{@dish.id}", params: { name: nil },
                                 headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'returns an error for owners updating a non-existent dish' do
      put '/dishes/999', params: { name: 'dal' },
                         headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner.id)}" }
      expect(response).to have_http_status(:not_found)
    end
    it 'returns an error for other owner trying to update a dish' do
      post '/dishes',
           params: { name: 'Dish Name', price: 9.99, restaurant_id: @restaurant.id, category_id: @category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner1.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /dishes/:id' do
    it 'deletes a dish for owners' do
      delete "/dishes/#{@dish.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for owner trying to delete a dish' do
      post '/dishes',
           params: { name: 'Dish Name', price: 9.99, restaurant_id: @restaurant.id, category_id: @category.id }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner1.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it 'returns an error for owners trying to delete a non-existent dish' do
      delete '/dishes/999', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner.id)}" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /dishes/owner_dishes' do
    it 'show owner dishes filter with dishe name ' do
      get '/dishes/owner_dishes', params: { name: 'panner' },
                                  headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it 'show owner dishes filter with category id ' do
      get '/dishes/owner_dishes', params: { category_id: 1 },
                                  headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
