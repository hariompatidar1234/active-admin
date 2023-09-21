class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[show update destroy]

  def index
    restaurants = Restaurant.all
    restaurants = if params[:name]
                    restaurants.where('name LIKE ?', "%#{params[:name]}%")
                  elsif params[:status]
                    restaurants.where(status: params[:status])
                  else
                    restaurants.page(params[:page]).per(5)
                  end
    render json: restaurants
  end

  def show
    byebug
    dishes = @restaurant.dishes
    dishes = if params[:category_id]
              dishes.where(category_id: "#{params[:category_id]}")
            elsif params[:name]
              @restaurant.dishes.where('name LIKE ?', "%#{params[:name]}%")
            end
    render json: dishes.any? ? dishes : @restaurant
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
    if @restaurant.owner == @current_user
      if @restaurant.update(restaurant_params)
        render json: { data: @restaurant, message: 'Updated successfully' }
      else
        render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to update this restaurant' }, status: :unauthorized
    end
  end

  def destroy
    if @restaurant.owner == @current_user
      if @restaurant.destroy
        render json: { data: @restaurant, message: 'Restaurant deleted successfully' }
      else
        render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to delete this restaurant' }, status: :unauthorized
    end
  end

  def my_restaurants_list
    restaurants = @current_user.restaurants
    if restaurants.any?
      render json: restaurants
    else
      render json: { message: "You haven't added any restaurants yet." }, status: :ok
    end
  end

  private

  def restaurant_params
    params.permit(:name, :status, :address, :picture)
  end

  def set_restaurant
    @restaurant = Restaurant.find_by_id(params[:id])
    render json: { message: 'Restaurant not found' }, status: :not_found unless @restaurant
  end
end
