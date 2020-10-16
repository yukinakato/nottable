class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable,
         :omniauthable, omniauth_providers: [:facebook]

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
  has_many :notifications, dependent: :destroy

  has_one_attached :avatar
  validates :avatar,
            content_type: {
              in: %w(image/jpeg image/gif image/png),
              message: "ファイル形式が正しくありません。",
            },
            size: { less_than: 2.megabytes, message: "の最大ファイルサイズは 2MB です。" }

  def bookmark(note)
    bookmarked_notes << note
  end

  def unbookmark(note)
    bookmarks.find_by(note: note).destroy
  end

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
  def unread_notifications_length
    notifications.where(unread: true).length
  end

  # 自分の通知をすべて既読にする
  def mark_notifications_read_all
    notifications.update_all(unread: false)
  end

  # ブックマーク取得（自分のノートは全て、他人のノートはプライベートでないもののみ）
  # def bookmarked_notes_filtered
  #   bookmarked_notes.where("notes.user_id = ? OR private = false", id)
  # end

  # 与えられたノートの内容を見る権限があるかどうか
  def prohibited?(note)
    (note.user != self) && note.private
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.display_name = auth.info.name
      user.from_sns = true
    end
  end
end
