class ChangeMpesaTransactionIdInTransactions < ActiveRecord::Migration[7.2]
  def change
    change_column_null :transactions, :mpesa_transaction_id, true
  end
end