class CreateMarkdownNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :markdown_notes do |t|
      t.text :content

      t.timestamps
    end
  end
end
