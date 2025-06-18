class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.datetime :date
      t.decimal :total_amount
      t.decimal :discount
      t.string :payment_method
      t.string :status
      t.references :mpesa_transaction, null: false, foreign_key: true

      t.timestamps
    end
  end
end
