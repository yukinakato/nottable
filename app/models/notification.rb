class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notification_entity, polymorphic: true
end
