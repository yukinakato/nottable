class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false, default: ""
      t.boolean :private, null: false, default: false
      t.references :note_entity, polymorphic: true

      t.timestamps
    end
  end
end
