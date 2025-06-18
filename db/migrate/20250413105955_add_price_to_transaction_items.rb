class AddPriceToTransactionItems < ActiveRecord::Migration[7.2]
  def change
    add_column :transaction_items, :price, :decimal
  end
end
