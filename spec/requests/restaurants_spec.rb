require 'rails_helper'
include JsonWebToken
RSpec.describe "Restaurants", type: :request do
  let!(:restaurant){ FactoryBot.create(:restaurant) }
    let!(:user) { FactoryBot.create(:user) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }

  describe "GET /restaurants" do
    it "Restaurants name " do
     get '/restaurants',params: {name: restaurant.name}, headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it "Restaurants address " do
      get '/restaurants' , params: {address: restaurant.address} , headers: {'Authorization' => "Bearer #{valid_jwt}"}
      expect(response).to have_http_status(:ok)
    end
    it "Restaurants status" do
      get '/restaurants', params: {status: restaurant.status} , headers: {'Authorization' => "Bearer #{valid_jwt}"}
      expect(response).to have_http_status(:ok)
    end
    it "Restaurants page" do
      get '/restaurants', params: {page: 2},headers: {'Authorization' =>"Bearer #{valid_jwt}"}
      expect(response).to have_http_status(:ok)
    end
  end

  # describe 'POST /restaurants' do
  #   # restaurant1= FactoryBot.build(:restaurant)
  #   it 'return created successfully' do
  #     post '/restaurants' , params: {name: "mahakal",address: "ujjain",status: "open"}, headers: {Authorization: "Bearer #{valid_jwt}"}
  #     expect(response).to have_http_status(201)
  #   end
  #   it  'return unprocessable_entity message' do
  #     post '/restaurants' , params: { name: nil,address: nil }, headers: {Authorization: "bearer #{valid_jwt}"}
  #     expect(response).to have_http_status(422)
  #   end
  # end

  describe "GET /restaurants/id" do
    it "return restaurant" do
      get "/restaurants/#{restaurant.id}", headers: { Authorization: "bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /restaurants/id" do
     user1= FactoryBot.create(:user,type: 'Owner')
    rest1= FactoryBot.create(:restaurant, user_id: user1.id)
    it "update restaurant"do
      put "/restaurants/#{rest1.id}",params: {name: "rasoi"} ,headers: { Authorization: "bearer #{jwt_encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "invalid credentials"do
      put "/restaurants/#{rest1.id}",params: {name: nil} ,headers: { Authorization: "bearer #{jwt_encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
      it "return unauthorized" do
      put "/restaurants/#{restaurant.id}", headers: { Authorization: "bearer #{valid_jwt}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE / restaurants/id' do
    user2= FactoryBot.create(:user,type: 'Owner')
    rest2= FactoryBot.create(:restaurant, user_id: user2.id)
    it "delete owner restaurant" do
      delete "/restaurants/#{rest2.id}", headers: { Authorization: "bearer #{jwt_encode(user_id: user2.id)}" }
      expect(response).to have_http_status(:ok)
    end
      it "return unauthorized" do
        user5= FactoryBot.create(:user,type: 'Owner')
        rest5= FactoryBot.create(:restaurant, user_id: user5.id)
        byebug
        put "/restaurants/#{rest5.id}", headers: { Authorization: "bearer #{valid_jwt}" }
        expect(response.status).to eq(401)
    end
  end

  describe "PUT /restaurants/my_restaurants_list" do
    it "owner restaurant" do
      user3= FactoryBot.create(:user,type: 'Owner')
      rest3= FactoryBot.create(:restaurant, user_id: user3.id)
      put "/restaurants/my_restaurants_list",headers: { Authorization: "bearer #{jwt_encode(user_id: user3.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
