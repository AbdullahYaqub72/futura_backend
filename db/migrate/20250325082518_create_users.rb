class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.decimal :revenue
      t.string :revenue_type
      t.string :password
      t.string :role

      t.timestamps
    end
  end
end
