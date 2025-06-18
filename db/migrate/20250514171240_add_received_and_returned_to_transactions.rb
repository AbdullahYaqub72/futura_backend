class AddReceivedAndReturnedToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :received_amount, :decimal
    add_column :transactions, :returned_amount, :decimal
  end
end
