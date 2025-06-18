class CreateMpesaTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :mpesa_transactions do |t|
      t.decimal :total_amount
      t.string :code
      t.string :status
      t.datetime :date

      t.timestamps
    end
  end
end
