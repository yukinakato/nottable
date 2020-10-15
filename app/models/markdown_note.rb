class MarkdownNote < ApplicationRecord
  has_one :note, as: :note_entity, dependent: :destroy

  validates :content, length: { maximum: Constants::NOTE_CONTENT_MAX_LENGTH }
  # scope :search, -> (keyword) { where("content LIKE ?", "%#{keyword}%") }
end
