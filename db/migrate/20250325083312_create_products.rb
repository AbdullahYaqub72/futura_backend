class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :quantity
      t.decimal :price
      t.references :product_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
