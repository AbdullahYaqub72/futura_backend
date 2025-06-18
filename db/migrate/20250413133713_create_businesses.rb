class CreateBusinesses < ActiveRecord::Migration[7.2]
  def change
    create_table :businesses do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
