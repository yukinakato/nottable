class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :unread, null: false, default: true
      t.references :notification_entity, polymorphic: true

      t.timestamps
    end
  end
end
