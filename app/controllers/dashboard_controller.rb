class DashboardController < ApplicationController
  before_action :set_business

  # GET /dashboard/transaction_totals_by_type
  def transaction_totals_by_type
    data = Transaction.where(business_id: @business.id).group(:payment_method).sum(:total_amount)
    formatted = data.map { |type, amount| { payment_method: type, total_amount: amount.to_f.round(2) } }
    render json: { data: formatted, generated_at: Time.zone.now }
  end

  # GET /dashboard/sales_summary
  def sales_summary
    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    transactions = Transaction.where(business_id: @business.id, date: today_range).select(
      "SUM(total_amount) AS sales_today",
      "AVG(total_amount) AS average_sales_value",
      "COUNT(*) AS total_transactions"
    ).take

    render json: {
      sales_today: transactions.sales_today.to_f.round(2),
      average_sales_value: transactions.average_sales_value.to_f.round(2),
      total_transactions: transactions.total_transactions
    }
  end

  # GET /dashboard/recent_transactions
  def recent_transactions
    limit = params[:limit].present? ? params[:limit].to_i : 50
    transactions = Transaction.where(business_id: @business.id).includes(:user, transaction_items: :product).order(created_at: :desc).limit(limit)
    data = transactions.map do |txn|
      { id: txn.id, amount: txn.total_amount, payment_method: txn.payment_method, status: txn.status, created_at: txn.created_at, customer_id: txn.customer_id, 
        user: { id: txn.user_id, name: txn.user&.name },
        transaction_items: txn.transaction_items.map do |item|
          { id: item.id, product_id: item.product_id, price: item.price, quantity: item.quantity, product_name: item.product&.name }
        end
      }
    end
    render json: { recent_transactions: data }
  end

  private

  def set_business
    @business = current_user.business
    render json: { error: "Business not found" }, status: :not_found unless @business
  end
end