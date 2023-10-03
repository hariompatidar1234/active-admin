class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show update destroy]

  def index
    categories = Category.all
    render json: categories
  end

  def show
    render json: @category
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
    render json: @category
  end

  def update
    if @category.update(category_params)
      render json: { data: @category, message: 'Category updated' }
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      render json: { message: 'Category deleted' }
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.permit(:name)
  end

  def set_category
    @category = Category.find_by_name(params[:category_name])
    render json: { error: 'Category not found by name' }, status: :not_found unless @category
  end
end
