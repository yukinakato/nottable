class Note < ApplicationRecord
  belongs_to :user
  belongs_to :note_entity, polymorphic: true

  validates :title, presence: true, length: { maximum: Constants::NOTE_TITLE_MAX_LENGTH }

  scope :no_private, -> { where(private: false) }
end
