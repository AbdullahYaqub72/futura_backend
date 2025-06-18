class CreatePermissionsRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :permissions_roles do |t|
      t.references :role, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
