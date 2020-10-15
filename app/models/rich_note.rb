class RichNote < ApplicationRecord
  has_one :note, as: :note_entity, dependent: :destroy

  has_rich_text :content
end
