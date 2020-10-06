class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable
  # :omniauthable

  validates :display_name, presence: true, length: { maximum: Constants::USER_DISPLAY_NAME_MAX_LENGTH }
  validates :introduce, length: { maximum: Constants::USER_INTRODUCE_MAX_LENGTH }

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :notes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_notes, through: :bookmarks, source: :note
  # has_many :notifications, dependent: :destroy

  def bookmarked?(note)
    bookmarked_notes.include?(note)
  end

  def follow(user)
    following << user
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end

  # 未読通知数を取得する
  # def unread_notifications
  #   notifications.where(unread: true).count
  # end
end
