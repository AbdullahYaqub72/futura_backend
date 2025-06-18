class ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :set_product, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /products
  def index
    @products = Product.where(business_id: current_user.business_id)
    render json: @products
  end

  # GET /products/:id
  def show
    render json: @product
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    @product.business_id = current_user.business_id
    if @product.save
      InventoryLog.create!(
        product: @product,
        change_quantity: @product.quantity,
        date: Time.current,
        reason: "Product created with initial stock"
      )
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/:id
  def update
    old_quantity = @product.quantity
    if @product.update(product_params)
      if product_params[:quantity]
        quantity_diff = @product.quantity.to_i - old_quantity.to_i
        if quantity_diff != 0
          InventoryLog.create!(product: @product, change_quantity: quantity_diff, date: Time.current, reason: "Stock updated")
        end
      end
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def destroy
    InventoryLog.create!(product: @product, change_quantity: -@product.quantity, date: Time.current, reason: "Product deleted")
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id], business_id: current_user.business_id)
    unless @product
      render json: { error: 'Product not found or access denied' }, status: :not_found
    end
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :quantity, :buying_price, :selling_price, :product_category_id, product_category_attributes: [:name, :description]
    )
  end
end