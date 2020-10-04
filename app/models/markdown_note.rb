class MarkdownNote < ApplicationRecord
  has_one :note, as: :entity

  validates :content, length: { maximum: Constants::NOTE_CONTENT_MAX_LENGTH }
end
