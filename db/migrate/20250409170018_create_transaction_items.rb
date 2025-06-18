class CreateTransactionItems < ActiveRecord::Migration[7.2]
  def change
    create_table :transaction_items do |t|
      t.references :transaction_record, null: false, foreign_key: { to_table: :transactions }
      t.references :product, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
