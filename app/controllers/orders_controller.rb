class OrdersController < ApplicationController
  before_action :find_order, only: [:show]

  def index
    @orders = current_user.orders
    render json: @orders, status: :ok
  end

  def create
    @cart = current_user.cart
    if @cart.cart_items.empty?
      render json: { message: 'Cart is empty. Cannot create an order with an empty cart.' },
             status: :unprocessable_entity
    else
      @order = current_user.orders.new(address: params[:address])

      if @order.save
        # OrderMailer.orzder_confirm(@current_user).deliver_now
        create_order_items(@order)
        render json: { data: @order, message: 'Order created successfully!' },
               status: :created
      else
        render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def show
    @orders = current_user.orders
    render json: @orders, status: :ok
  end

  def create_order_items(order)
    cart_items = current_user.cart.cart_items.includes(:dish)
    cart_items.each do |cart_item|
      order_item = order.order_items.new(
        dish_id: cart_item.dish.id,
        quantity: cart_item.quantity,
        total_amount: cart_item.quantity * cart_item.dish.price
      )
      order_item.save
    end
    current_user.cart.cart_items.destroy_all
  end

  private

  def find_order
    @order = current_user.orders.find_by_id(params[:id])
    render json: { error: 'Order not found' }, status: :not_found unless @order
  end
end
