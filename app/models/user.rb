class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable
  # :omniauthable

  validates :display_name, presence: true, length: { maximum: Constants::USER_DISPLAY_NAME_MAX_LENGTH }
  validates :introduce, length: { maximum: Constants::USER_INTRODUCE_MAX_LENGTH }
end
