class AddSalesTransactionToInventoryLogs < ActiveRecord::Migration[7.2]
  def change
    add_reference :inventory_logs, :sales_transaction, null: true, foreign_key: { to_table: :transactions }
  end
end