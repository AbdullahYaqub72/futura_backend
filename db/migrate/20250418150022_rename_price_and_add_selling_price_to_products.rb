class RenamePriceAndAddSellingPriceToProducts < ActiveRecord::Migration[7.2]
  def change
    rename_column :products, :price, :buying_price
    add_column :products, :selling_price, :decimal
  end
end