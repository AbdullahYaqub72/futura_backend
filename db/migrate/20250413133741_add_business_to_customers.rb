class AddBusinessToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_reference :customers, :business, foreign_key: true
  end
end
