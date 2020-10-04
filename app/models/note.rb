class Note < ApplicationRecord
  belongs_to :user
  belongs_to :entity, polymorphic: true

  validates :title, presence: true, length: { maximum: NOTE_TITLE_MAX_LENGTH }
end
