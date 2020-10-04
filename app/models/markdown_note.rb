class MarkdownNote < ApplicationRecord
  has_one :note, as: :note_entity

  validates :content, length: { maximum: Constants::NOTE_CONTENT_MAX_LENGTH }
end
