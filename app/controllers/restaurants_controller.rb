class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[show update destroy]
  before_action :authenticate_request
  load_and_authorize_resource
  
  def index
    page_number = params[:page]
    if params[:page].nil?
      render json: Restaurant.all
    else
      restaurant= Restaurant.all.page(page_number).per(2)
      render json: restaurant
    end
  end 
  
  def show
    render json: @restaurant
  end
  
  def create
    restaurant = @current_user.restaurants.new(restaurant_params)
    if restaurant.save
      render json: { data: restaurant, message: 'Restaurant added successfully' }, status: :created
    else
      render json: { errors: restaurant.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @restaurant.update(restaurant_params)
      render json: { data: @restaurant, message: 'Updated successfully' }
    else
      render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @restaurant.destroy
      render json: { data: @restaurant, message: 'Deleted successfully' }
    else
      render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def search_restaurant_by_name
    name = params[:name]
    restaurant = Restaurant.where('name LIKE ?', "%#{name}%")
    render json: restaurant, status: :ok
  end
  
  private
  
  def restaurant_params
    params.permit(:name, :status, :address, :picture)
  end
  
  def set_restaurant
    @restaurant = Restaurant.find_by_name(params[:restaurant_name])
  end
end