class AddDescriptionToRoles < ActiveRecord::Migration[7.2]
  def change
    add_column :roles, :description, :text
  end
end
