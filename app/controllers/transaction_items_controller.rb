class TransactionItemsController < ApplicationController
  before_action :set_transaction_item, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token

  # GET /transaction_items
  def index
    @transaction_items = TransactionItem.all
    render json: @transaction_items
  end

  # GET /transaction_items/:id
  def show
    render json: @transaction_item
  end

  # POST /transaction_items
  def create
    @transaction_item = TransactionItem.new(transaction_item_params)
    if @transaction_item.save
      render json: @transaction_item, status: :created
    else
      render json: @transaction_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transaction_items/:id
  def update
    if @transaction_item.update(transaction_item_params)
      render json: @transaction_item
    else
      render json: @transaction_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transaction_items/:id
  def destroy
    @transaction_item.destroy
    head :no_content
  end

  private

  def set_transaction_item
    @transaction_item = TransactionItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Transaction Item not found" }, status: :not_found
  end

  def transaction_item_params
    params.require(:transaction_item).permit(:product_id, :quantity, :transaction_record_id)
  end
end