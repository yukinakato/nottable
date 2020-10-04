class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :note

  has_one :notification, as: :notify_entity, dependent: :destroy
end
