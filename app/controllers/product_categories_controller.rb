class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource

  # GET /product_categories
  def index
    @product_categories = ProductCategory.where(business_id: current_user.business_id)
    render json: @product_categories
  end

  # GET /product_categories/:id
  def show
    render json: @product_category
  end

  # POST /product_categories
  def create
    @product_category = ProductCategory.new(product_category_params)
    @product_category.business_id = current_user.business_id

    if @product_category.save
      render json: @product_category, status: :created
    else
      render json: @product_category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_categories/:id
  def update
    if @product_category.update(product_category_params)
      render json: @product_category
    else
      render json: @product_category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_categories/:id
  def destroy
    @product_category.destroy
    head :no_content
  end

  private

  def set_product_category
    @product_category = ProductCategory.find_by(id: params[:id], business_id: current_user.business_id)
    unless @product_category
      render json: { error: "Product category not found or access denied" }, status: :not_found
    end
  end

  def product_category_params
    params.require(:product_category).permit(:name, :description)
  end
end