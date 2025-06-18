class AddBusinessToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_reference :transactions, :business, foreign_key: true
  end
end
