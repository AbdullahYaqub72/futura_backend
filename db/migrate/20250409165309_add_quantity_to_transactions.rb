class AddQuantityToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :quantity, :integer
  end
end
