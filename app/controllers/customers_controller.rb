class CustomersController < ApplicationController
  load_and_authorize_resource
  before_action :set_customer, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token

  # GET /customers
  def index
    customers = Customer.where(business_id: current_user.business_id)
    render json: customers
  end

  # GET /customers/:id
  def show
    render json: @customer
  end

  # POST /customers
  def create
    customer = Customer.new(customer_params)
    customer.business_id = current_user.business_id
    if customer.save
      render json: customer, status: :created
    else
      render json: customer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customers/:id
  def update
    if @customer.update(customer_params)
      render json: @customer
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customers/:id
  def destroy
    @customer.destroy
    head :no_content
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Customer not found' }, status: :not_found
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :phone, :gender, :email, :date_of_birth)
  end
end
