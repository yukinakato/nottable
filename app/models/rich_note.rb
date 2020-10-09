class RichNote < ApplicationRecord
  has_one :note, as: :note_entity

  has_rich_text :content
end
