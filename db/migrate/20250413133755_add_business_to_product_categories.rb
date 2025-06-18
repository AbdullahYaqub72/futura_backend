class AddBusinessToProductCategories < ActiveRecord::Migration[7.2]
  def change
    add_reference :product_categories, :business, foreign_key: true
  end
end
