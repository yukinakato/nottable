class AddColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :display_name, :string, null: false
    add_column :users, :introduce, :string
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
