class AddBusinessToProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :business, foreign_key: true
  end
end
