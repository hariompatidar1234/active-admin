class CartsController < ApplicationController
  before_action :find_cart_item, only: %i[show update destroy]
  before_action :cart_not_empty?, only: %i[index update show destroy]

  def index
    render json: @current_user.cart
  end

  def create
    @cart = @current_user.cart || @current_user.create_cart
    @dish = Dish.find_by_id(cart_item_params[:dish_id])

    unless @dish
      return render json: { errors: 'Dish not found' }, status: :not_found
    end

    if @cart.cart_items.empty? || same_restaurant?(@cart, @dish.restaurant)
      @cart_item = @cart.cart_items.new(dish: @dish, quantity: cart_item_params[:quantity])

      if @cart_item.save
        render json: { message: 'CartItem added to cart successfully!', data: @cart_item }, status: :created
      else
        render json: { errors: @cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'CartItems could not be added to cart for a different restaurant' },
             status: :unprocessable_entity
    end
  end

  def show
    if @cart_item
      render json: @cart_item
    else
      render json: { errors: 'Cart Item not found' }, status: :not_found
    end
  end

  def update
    if @cart_item
      new_quantity = params[:quantity].to_i
      if new_quantity.positive?
        @cart_item.update(quantity: new_quantity)
        render json: { message: 'Cart Item quantity updated successfully', data: @cart_item }, status: :ok
      else
        render json: { errors: 'Quantity must be greater than 0' }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'Cart Item not found' }, status: :not_found
    end
  end

  def destroy
    if @cart_item
      @cart_item.destroy
      render json: 'Cart Item Removed Successfully', status: :ok
    else
      render json: 'Cart Item not found', status: :not_found
    end
  end

  def destroy_all
    cart_items = @current_user.cart.cart_items

    if cart_items.any?
      cart_items.destroy_all
      render json: 'All Cart Items Removed Successfully', status: :ok
    else
      render json: 'Cart is empty'
    end
  end

  private

  def cart_item_params
    params.permit(:quantity, :dish_id)
  end

  def same_restaurant?(cart, restaurant)
    cart.cart_items.empty? || cart.cart_items.first.dish.restaurant == restaurant
  end

  def find_cart_item
    @cart_item = @current_user.cart.cart_items.find_by_id(params[:id])
  end

  def cart_not_empty?
    if @current_user.cart.cart_items.empty?
      render json: { errors: 'Cart is empty' }, status: :unprocessable_entity
    end
  end
end
