class CreateRolesUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :roles_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
