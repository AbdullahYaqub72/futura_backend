class InventoryLogsController < ApplicationController
  load_and_authorize_resource
  before_action :set_inventory_log, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token

  # GET /inventory_logs
  def index
    @inventory_logs = InventoryLog.includes(:product).all
    render json: @inventory_logs.as_json(include: :product)
  end

  # GET /inventory_logs/:id
  def show
    render json: @inventory_log
  end

  # POST /inventory_logs
  def create
    @inventory_log = InventoryLog.new(inventory_log_params)
    if @inventory_log.save
      render json: @inventory_log, status: :created
    else
      render json: @inventory_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /inventory_logs/:id
  def update
    if @inventory_log.update(inventory_log_params)
      render json: @inventory_log
    else
      render json: @inventory_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /inventory_logs/:id
  def destroy
    @inventory_log.destroy
    head :no_content
  end

  private

  def set_inventory_log
    @inventory_log = InventoryLog.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Inventory Log not found" }, status: :not_found
  end

  def inventory_log_params
    params.require(:inventory_log).permit(:product_id, :change_quantity, :date, :reason, :sales_transaction_id,
                                          product_attributes: [:id, :name, :description, :quantity, :buying_price, :selling_price, :product_category_id, :business_id]
    )
  end
end