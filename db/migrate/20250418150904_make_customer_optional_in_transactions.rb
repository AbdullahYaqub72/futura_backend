class MakeCustomerOptionalInTransactions < ActiveRecord::Migration[7.2]
  def change
    change_column_null :transactions, :customer_id, true
  end
end