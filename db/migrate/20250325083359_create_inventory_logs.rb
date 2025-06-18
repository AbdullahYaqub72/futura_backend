class CreateInventoryLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :inventory_logs do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :change_quantity
      t.datetime :date
      t.string :reason

      t.timestamps
    end
  end
end
