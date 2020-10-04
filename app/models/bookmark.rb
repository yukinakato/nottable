class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :note

  has_one :notification, as: :notification_entity, dependent: :destroy
end
