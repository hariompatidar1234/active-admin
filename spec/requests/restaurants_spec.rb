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

  describe "POST /restaurants" do
    context "when the user is an owner" do
      it "creates a restaurant successfully" do
        owner = FactoryBot.create(:user, type: 'Owner')
        post '/restaurants', params: { name: "Mahakal", address: "Ujjain", status: "open" },
             headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }

        expect(response).to have_http_status(201)
      end

      it "returns unprocessable_entity for invalid data" do
        owner = FactoryBot.create(:user, type: 'Owner')

        post '/restaurants', params: { name: nil, address: nil },
             headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }

        expect(response).to have_http_status(422)
      end
    end
  end

  describe "GET /restaurants/id" do
    it "return restaurant" do
      get "/restaurants/#{restaurant.id}", headers: { Authorization: "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /restaurants/id" do
    it "updates the restaurant successfully" do
      owner = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)

      put "/restaurants/#{restaurant.id}", params: { name: "New Restaurant Name" },
          headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }

      expect(response).to have_http_status(200) # You expect a 200 status for a successful update
    end
    it "returns unprocessable_entity for invalid data" do
      owner = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)

      put "/restaurants/#{restaurant.id}", params: { name: nil },
          headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(422)
    end
    it "returns unauthorized" do
      owner = FactoryBot.create(:user, type: 'Owner')
      # restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      put "/restaurants/#{restaurant.id}", params: { name: "New Restaurant Name" },
          headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(401)
    end
    it "returns unauthorized for an invalid JWT" do
      restaurant = FactoryBot.create(:restaurant)
      put "/restaurants/#{restaurant.id}", params: { name: "New Restaurant Name" },
          headers: { 'Authorization' => "Bearer InvalidToken" }
      expect(response).to have_http_status(500)
    end
  end

  describe 'DELETE / restaurants/id' do
    user2= FactoryBot.create(:user,type: 'Owner')
    rest2= FactoryBot.create(:restaurant, user_id: user2.id)
    it "delete owner restaurant" do
      delete "/restaurants/#{rest2.id}", headers: { Authorization: "bearer #{jwt_encode(user_id: user2.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "returns unauthorized" do
      owner = FactoryBot.create(:user, type: 'Owner')
      owner1 = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: owner1.id)
      delete "/restaurants/#{restaurant.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }

      expect(response).to have_http_status(:unauthorized) # Expect a 401 status for unauthorized access
    end
  end

  describe " GET /restaurants/my_restaurants_list" do
    it "returns a list of owner's restaurants" do
      user_owner = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: user_owner.id)
       get "/restaurants/my_restaurants_list", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: user_owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "no restaurant found" do
      owner = FactoryBot.create(:user, type: 'Owner')
      owner1 = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: owner1.id)
      get "/restaurants/my_restaurants_list", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(404)
    end

  end
end
