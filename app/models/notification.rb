class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notify_entity, polymorphic: true
end
