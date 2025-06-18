class AddEmailAndDateOfBirthToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :email, :string
    add_column :customers, :date_of_birth, :date
  end
end
