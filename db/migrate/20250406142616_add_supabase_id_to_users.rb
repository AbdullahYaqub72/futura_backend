class AddSupabaseIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :supabase_id, :string
  end
end
