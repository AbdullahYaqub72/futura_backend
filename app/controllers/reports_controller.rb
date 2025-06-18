class ReportsController < ApplicationController
  # GET /reports/daily
  def daily
    start_of_day = Time.zone.now.beginning_of_day
    end_of_day = Time.zone.now.end_of_day
    transactions = Transaction.where(date: start_of_day..end_of_day)

    render json: generate_report(transactions, "Daily Report")
  end

  # GET /reports/monthly
  def monthly
    start_of_month = Time.zone.now.beginning_of_month
    end_of_month = Time.zone.now.end_of_month
    transactions = Transaction.where(date: start_of_month..end_of_month)

    render json: generate_report(transactions, "Monthly Report")
  end

  # GET /reports/yearly
  def yearly
    start_of_year = Time.zone.now.beginning_of_year
    end_of_year = Time.zone.now.end_of_year
    transactions = Transaction.where(date: start_of_year..end_of_year)

    render json: generate_report(transactions, "Yearly Report")
  end

  def generate_report(transactions, title)
    total_sales = transactions.sum(:total_amount)
    total_discounts = transactions.sum(:discount)
    total_transactions = transactions.count
    payment_methods = transactions.group(:payment_method).count
    statuses = transactions.group(:status).count

    {
      report_title: title,
      total_sales: total_sales,
      total_discounts: total_discounts,
      total_transactions: total_transactions,
      payment_method_breakdown: payment_methods,
      transaction_status_breakdown: statuses,
      generated_at: Time.zone.now
    }
  end

  def grouped_by_category_and_payment_method
    transactions = Transaction
                     .includes(:transaction_items)
                     .where(date: @start_date..@end_date, business_id: current_user.business_id)

    grouped_data = {}

    transactions.each do |txn|
      txn.transaction_items.each do |item|
        category = item.product&.product_category&.name || "Unknown"
        payment_method = txn.payment_method || "Unknown"

        key = [category, payment_method]
        grouped_data[key] ||= { total_transactions: Set.new, total_revenue: 0.0 }

        grouped_data[key][:total_transactions] << txn.id
        grouped_data[key][:total_revenue] += item.price.to_f * item.quantity.to_i
      end
    end

    result = grouped_data.map do |(category, payment_method), data|
      {
        category: category,
        payment_method: payment_method,
        total_transactions: data[:total_transactions].size,
        total_revenue: data[:total_revenue].round(2)
      }
    end

    render json: {
      report_title: "Custom Report",
      start_date: @start_date,
      end_date: @end_date,
      grouped_data: result,
      generated_at: Time.zone.now
    }
  end

  def yearly_by_category
    start_of_year = Time.zone.now.beginning_of_year
    end_of_year = Time.zone.now.end_of_year

    transactions = Transaction
                     .includes(transaction_items: :product)
                     .where(date: start_of_year..end_of_year, business_id: current_user.business_id)

    monthly_data = {}

    transactions.each do |txn|
      month_name = txn.date.strftime("%B")
      txn.transaction_items.each do |item|
        category = item.product&.product_category&.name || "Unknown"
        key = [month_name, category]
        monthly_data[key] ||= 0.0
        monthly_data[key] += item.price.to_f * item.quantity.to_i
      end
    end

    result = monthly_data.map do |(month, category), revenue|
      {
        month: month,
        category: category,
        total_revenue: revenue.round(2)
      }
    end

    render json: {
      report_title: "Yearly Category-wise Revenue Report",
      year: Time.zone.now.year,
      monthly_breakdown: result,
      generated_at: Time.zone.now
    }
  end

  # GET /reports/daily_by_category
  def daily_by_category
    start_of_day = Time.zone.now.beginning_of_day
    end_of_day = Time.zone.now.end_of_day

    transactions = Transaction
                     .includes(transaction_items: :product)
                     .where(date: start_of_day..end_of_day, business_id: current_user.business_id)

    category_data = {}

    transactions.each do |txn|
      txn.transaction_items.each do |item|
        category = item.product&.product_category&.name || "Unknown"
        category_data[category] ||= { total_revenue: 0.0, transaction_ids: Set.new }
        category_data[category][:total_revenue] += item.price.to_f * item.quantity.to_i
        category_data[category][:transaction_ids] << txn.id
      end
    end

    result = category_data.map do |category, data|
      {
        category: category,
        total_revenue: data[:total_revenue].round(2),
        transactions_count: data[:transaction_ids].size
      }
    end

    render json: {
      report_title: "Daily Category-wise Report",
      date: Time.zone.today,
      category_breakdown: result,
      generated_at: Time.zone.now
    }
  end

  def daily_transactions_summary
    end_date = Time.zone.now
    start_date = end_date - 5.days

    category_ids = params[:product_category_ids] || []
    category_filter_join = ""
    category_filter_where = ""

    if category_ids.any?
      category_ids = category_ids.map(&:to_i)
      category_filter_join = <<-SQL
      INNER JOIN transaction_items ON transaction_items.transaction_record_id = transactions.id
      INNER JOIN products ON products.id = transaction_items.product_id
    SQL
      category_filter_where = "AND products.product_category_id IN (#{category_ids.join(',')})"
    end

    sql = <<-SQL
    SELECT DATE(transactions.date) AS day, COUNT(DISTINCT transactions.id) AS transactions_count
    FROM transactions
    #{category_filter_join}
    WHERE transactions.date BETWEEN '#{start_date.beginning_of_day}' AND '#{end_date.end_of_day}'
    AND transactions.business_id = #{current_user.business_id}
    #{category_filter_where}
    GROUP BY day
    ORDER BY day ASC
  SQL

    raw_results = ActiveRecord::Base.connection.exec_query(sql).to_a
    summary_hash = raw_results.index_by { |r| r["day"].to_date }

    formatted_data = (start_date.to_date..end_date.to_date).map do |date|
      { date: date.strftime("%b %d"), transactions_count: summary_hash[date]&.[]("transactions_count")&.to_i || 0 }
    end

    render json: { report_title: "Last 5 Days Transaction Trend", data: formatted_data }
  end

  def inventory_valuation
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 20
    offset = (page - 1) * per_page
    scope = Product.where(business_id: current_user.business_id)
    products = scope.select(:id, :name, :buying_price, :quantity).limit(per_page).offset(offset).to_a
    total_count = scope.count
    data = products.map! do |product|
      quantity = product.quantity.to_i
      buying_price = product.buying_price.to_f
      { product_name: product.name, buying_price: buying_price, quantity: quantity, total_value: (buying_price * quantity).round(2) }
    end

    render json: { inventory_valuation: data,
      pagination: { page: page, per_page: per_page, total_records: total_count, total_pages: (total_count.to_f / per_page).ceil },
      generated_at: Time.zone.now }
  end

  def stock_availability_trend
    start_date = 6.days.ago.beginning_of_day.to_date
    category_ids = params[:product_category_ids] || []
    category_filter = if category_ids.any?
                        "AND products.product_category_id IN (#{category_ids.map(&:to_i).join(',')})"
                      else
                        ""
                      end

    sql = <<-SQL
    SELECT DATE(inventory_logs.created_at) AS log_date, SUM(change_quantity) AS items_left
    FROM inventory_logs
    INNER JOIN products ON products.id = inventory_logs.product_id
    WHERE products.business_id = #{current_user.business_id}
      AND inventory_logs.created_at >= '#{start_date}'
      #{category_filter}
    GROUP BY log_date
   SQL

    raw_results = ActiveRecord::Base.connection.exec_query(sql).to_a
    logs = raw_results.each_with_object({}) do |row, hash|
      hash[row["log_date"]] = row["items_left"].to_i
    end

    formatted = (0..6).map do |i|
      date = (start_date + i.days).to_date
      { day: date.strftime('%A'), items_left: logs[date] || 0 }
    end

    render json: { stock_availability_trend: formatted }
  end

  def monthly_stock_by_category
    months_back = params[:months].present? ? (params[:months])&.to_i : 5
    start_date = months_back.months.ago.beginning_of_month.to_date
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
    offset = (page - 1) * per_page

    sql = <<-SQL
    SELECT
      TO_CHAR(DATE_TRUNC('month', products.created_at), 'Month') AS month,
      product_categories.name AS category,
      SUM(products.quantity) AS total_quantity
    FROM products
    INNER JOIN product_categories ON product_categories.id = products.product_category_id
    WHERE products.business_id = #{current_user.business_id}
      AND products.created_at >= '#{start_date}'
    GROUP BY DATE_TRUNC('month', products.created_at), product_categories.name
    ORDER BY DATE_TRUNC('month', products.created_at) DESC
    LIMIT #{per_page} OFFSET #{offset}
    SQL

    raw_results = ActiveRecord::Base.connection.exec_query(sql).to_a
    grouped = raw_results.group_by { |row| row["month"] }
    all_categories = ProductCategory.where(business_id: current_user.business_id).pluck(:name)

    formatted = grouped.map do |month, rows|
      month_data = { month: month.strip }
      all_categories.each do |category|
        row = rows.find { |r| r["category"] == category }
        month_data[category.parameterize.underscore.to_sym] = row ? row["total_quantity"].to_i : 0
      end
      month_data
    end

    render json: { monthly_stock_by_category: formatted, pagination: { page: page, per_page: per_page, generated_at: Time.zone.now } }
  end

  private

  def fetch_category_quantity(rows, category)
    row = rows.find { |r| r["category"] == category }
    row ? row["total_quantity"].to_i : 0
  end

  private

  def set_date_range
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]).beginning_of_day : Time.zone.now.beginning_of_day
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]).end_of_day : Time.zone.now.end_of_day
  rescue ArgumentError
    render json: { error: 'Invalid date format. Use YYYY-MM-DD.' }, status: :bad_request
  end

end