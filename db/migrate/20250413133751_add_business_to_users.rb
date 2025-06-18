class AddBusinessToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :business, foreign_key: true
  end
end
