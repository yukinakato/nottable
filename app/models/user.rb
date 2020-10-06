class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable
  # :omniauthable

  validates :display_name, presence: true, length: { maximum: Constants::USER_DISPLAY_NAME_MAX_LENGTH }
  validates :introduce, length: { maximum: Constants::USER_INTRODUCE_MAX_LENGTH }

  # has_many :active_relationships, class_name: "Relationship",
  #                                 foreign_key: "follower_id",
  #                                 dependent: :destroy
  # has_many :passive_relationships, class_name: "Relationship",
  #                                  foreign_key: "followed_id",
  #                                  dependent: :destroy
  # has_many :following, through: :active_relationships, source: :followed
  # has_many :followers, through: :passive_relationships, source: :follower
  has_many :notes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_notes, through: :bookmarks, source: :note
  # has_many :notifications, dependent: :destroy

  def bookmarked?(note)
    bookmarked_notes.include?(note)
  end
end
