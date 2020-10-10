class AddColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :display_name, :string, null: false
    add_column :users, :introduce, :text
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_index :users, :display_name
  end
end
