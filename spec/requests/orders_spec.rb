require 'rails_helper'
include JsonWebToken
RSpec.describe OrdersController, type: :request do

  before   do
    @owner = FactoryBot.create(:user, type: "Owner")
    @user = FactoryBot.create(:user, type: "Customer")
    @restaurant = FactoryBot.create(:restaurant, user_id: @owner.id)
    @category = FactoryBot.create(:category)
    @dish = FactoryBot.create(:dish, restaurant_id: @restaurant.id, category_id: @category.id)
    @cart= FactoryBot.create(:cart, user_id: @user.id)
    @cartitem = FactoryBot.create(:cart_item, cart_id: @cart.id, dish_id: @dish.id)
    @order = FactoryBot.create(:order, user_id: @user.id)
    @orderitem = FactoryBot.create(:order_item,user_id: @user.id, dish_id: @dish.id)
  end

  describe "GET /orders" do
      it "order items list" do
        get "/orders", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
        expect(response).to have_http_status(:ok)
      end
  end

  describe 'POST /orders' do
    it 'creates a new order and clears the cart' do
      post "/order" ,params: { address: '123 Main St' }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
        expect(response).to have_http_status(:created)
    end
    it 'returns unprocessable entity status' do
      post "/order" ,params: { address: nil }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:unprocessable_entitys)
    end
    it 'returns unauthorized status' do
      post orders_path
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /orders/:id' do
    it 'returns the order for the current user' do
      get "/orders/1" , headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: @user.id) }" }
      expect(response).to have_http_status(:ok)
    end
  end
end
