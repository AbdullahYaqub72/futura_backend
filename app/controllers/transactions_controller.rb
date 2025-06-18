class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource

  # GET /transactions
  def index
    @transactions = Transaction.includes(:transaction_items, :mpesa_transaction).where(business_id: current_user.business_id)
    render json: @transactions, include: ['transaction_items', 'mpesa_transaction']
  end

  # GET /transactions/:id
  def show
    render json: @transaction, include: ['transaction_items', 'mpesa_transaction']
  end

  # POST /transactions
  def create
    transaction_data = params[:transaction][:transaction_data]
    @transaction = Transaction.new(transaction_params)
  
    if @transaction.save
      transaction_data.each do |item_param|
        permitted_item = item_param.permit(:product_id, :quantity, :price).to_h
      
        @transaction.transaction_items.create!(
          permitted_item.merge(transaction_record_id: @transaction.id)
        )
      
        product = Product.find(permitted_item[:product_id])
        product.update!(quantity: product.quantity - permitted_item[:quantity].to_i)
      
        InventoryLog.create!(
          product_id: product.id,
          change_quantity: -permitted_item[:quantity].to_i,
          date: Time.current,
          reason: "Sold in transaction #{@transaction.id}",
          sales_transaction_id: @transaction.id
        )
      end      
      render json: @transaction, status: :created, include: {
        transaction_items: { include: :product },
        mpesa_transaction: {}
      }
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/:id
  def update
    if @transaction.update(transaction_params)
      render json: @transaction, include: ['transaction_items', 'mpesa_transaction']
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/:id
  def destroy
    @transaction.destroy
    head :no_content
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Transaction not found" }, status: :not_found
  end

  def transaction_params
    params.require(:transaction).permit(
      :user_id, :business_id, :customer_id, :date, :total_amount, :discount, :payment_method, :status,
      :mpesa_transaction_id, :quantity, :received_amount, :returned_amount,
      mpesa_transaction_attributes: [:total_amount, :code, :status, :date]
    )
  end  
end