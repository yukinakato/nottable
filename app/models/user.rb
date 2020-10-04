class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable
  # :omniauthable

  validates :display_name, presence: true, length: { maximum: 50 }
  validates :introduce, length: { maximum: 100 }
end
