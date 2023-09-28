class DishesController < ApplicationController
  before_action :set_dish, only: %i[show update destroy]
  before_action :authorize_dish, only: %i[update destroy]

  def index
    if params[:restaurant_id]
      restaurant = Restaurant.find_by_id(params[:restaurant_id])
      render json: filter_dishes(restaurant.dishes)
    else
      dishes = Dish.all
      render json: filter_dishes(dishes)
    end
  end

  def show
    render json: @dish
  end

  def create
    restaurant = Restaurant.find_by_id(params[:restaurant_id])

    if restaurant && restaurant.owner == @current_user
      @dish = restaurant.dishes.new(dish_params)
      if @dish.save
        render json: { message: 'Dish added successfully!', data: @dish }, status: :created
      else
        render json: { errors: @dish.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to add a dish to this restaurant' }, status: :unauthorized
    end
  end

  def update
    if @dish.update(dish_params)
      render json: { data: @dish, message: 'Dish updated successfully!' }
    else
      render json: { errors: @dish.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @dish.destroy
      render json: { data: @dish, message: 'Dish successfully deleted' }
    else
      render json: { errors: 'Dish deletion failed' }
    end
  end

  def owner_dishes
    owner_dishes = @current_user.restaurants.map(&:dishes).flatten
    owner_dishes = owner_dishes.select { |dish| dish.name.downcase.include?(params[:name].downcase) } if params[:name].present?
    owner_dishes = owner_dishes.select { |dish| dish.category_id == params[:category_id].to_i } if params[:category_id].present?

    render json: owner_dishes
  end


  private

  def dish_params
    params.permit(:name, :price, :category_id, :restaurant_id, :picture)
  end

  def set_dish
    @dish = Dish.find_by_id(params[:id])
    render json: { errors: 'Dish not found' }, status: :not_found unless @dish
  end

  def authorize_dish
    return if @dish&.restaurant&.owner == @current_user

    render json: { error: 'You are not authorized to perform this action on this dish' }, status: :unauthorized
  end

  def filter_dishes(dishes)
    dishes = dishes.where(category_id: params[:category_id]) if params[:category_id]
    dishes = dishes.where('name LIKE ?', "%#{params[:name]}%") if params[:name]
    dishes = dishes.page(params[:page]).per(5) if params[:page]
    dishes
  end
end
