require 'rails_helper'
include JsonWebToken
RSpec.describe CartsController, type: :request do
  before   do
    @owner = FactoryBot.create(:user, type: "Owner")
    @user = FactoryBot.create(:user, type: "Customer")
    @restaurant = FactoryBot.create(:restaurant, user_id: @owner.id)
    @category = FactoryBot.create(:category)
    @dish = FactoryBot.create(:dish, restaurant_id: @restaurant.id, category_id: @category.id)
    @cart= FactoryBot.create(:cart, user_id: @user.id)
    @cartitem = FactoryBot.create(:cart_item, cart_id: @cart.id, dish_id: @dish.id)
  end

  describe "GET /carts" do
    it "cart list " do
      get "/carts", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /carts" do
    it "add cart item in the cart" do
      post "/carts" , params: {quantity: 5 , dish_id: 1}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:created)
    end
    it "returns an error for invalid cart creation" do
      post "/carts" , params: {quantity: nil , dish_id: @dish.id}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(422)
    end
    it "returns an error for invalid cart creation" do
      @restaurant1 = FactoryBot.create(:restaurant, user_id: @owner.id)
     # @category = FactoryBot.create(:category)
      @dish1 = FactoryBot.create(:dish, restaurant_id: @restaurant1.id, category_id: @category.id)
      post "/carts" , params: {quantity: 6 , dish_id: @dish1.id}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(422)
    end
  end

    describe 'GET /carts/:id' do
    it 'shows a cart item' do
      get "/carts/1", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error for a non-existent cart item' do
      get '/carts/999',headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /carts/:id' do
    it "update quantity in cart_item" do
      put "/carts/1" , params: { quantity: 4 }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:ok)
    end
    it "returns an error for a non-existent quantity in cart item" do
      put "/carts/1" , params: { quantity: nil }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it "returns an error for a non-existent  cart item" do
      put "/carts/999" , params: { quantity: 1 }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:not_found)
    end
  end
  describe 'DELETE /carts/:id' do
    it "delete  cart_item" do
      delete "/carts/1" , headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:ok)
    end
    it "returns an error for a non-existent cart item" do
      delete "/carts/9999" , headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /carts/:id' do
    it "delete  all cart_item" do
      delete "/carts/destroy_all" , headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:ok)
    end
    it "returns an error for a non-existent cart item" do
      delete "/carts/destroy_all" , headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:no_contant)
    end
  end

end
