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
    @orderitem = FactoryBot.create()
  end
