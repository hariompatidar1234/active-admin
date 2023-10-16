class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show update destroy]

  def index
    categories = Category.all
    render json: categories,status: :ok
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: { data: @category, message: 'Category created' }, status: :created
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @category,status: :ok
  end

  def update
    byebug
    if @category.update(category_params)
      render json: { data: @category, message: 'Category updated' },status: :ok
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      render json: { message: 'Category deleted' },status: :ok
    end
  end

  private

  def category_params
    params.permit(:name)
  end

  def set_category
    @category = Category.find_by_id(params[:id])
    render json: { error: 'Category not found by name' }, status: :not_found unless @category
  end
end
