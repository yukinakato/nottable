class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notify_entity, polymorphic: true

  validates :user_id, presence: true
  validates :notify_entity, presence: true

  scope :latest, -> { order(created_at: :desc) }
end
