class Note < ApplicationRecord
  belongs_to :user
  belongs_to :note_entity, polymorphic: true

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: Constants::NOTE_TITLE_MAX_LENGTH }
  validates :note_entity, presence: true

  has_many :bookmarks, dependent: :destroy

  scope :no_private, -> { where(private: false) }
  scope :search, -> (keyword) {
    joins("LEFT OUTER JOIN markdown_notes ON markdown_notes.id = notes.note_entity_id").
      joins("LEFT OUTER JOIN rich_notes ON rich_notes.id = notes.note_entity_id").
      joins("LEFT OUTER JOIN action_text_rich_texts ON action_text_rich_texts.record_id = rich_notes.id").
      where("title LIKE ? OR (note_entity_type = 'MarkdownNote' AND markdown_notes.content LIKE ?) OR (note_entity_type = 'RichNote' AND action_text_rich_texts.body LIKE ?)", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%").
      includes(:user, [note_entity: :rich_text_content])
  }
end
