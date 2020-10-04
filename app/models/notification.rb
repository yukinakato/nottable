class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notif_entity, polymorphic: true
end
