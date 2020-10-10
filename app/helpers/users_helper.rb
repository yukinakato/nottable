module UsersHelper
  # ユーザーのプロフィール画像を表示する image tag を生成
  def get_user_avatar(user, size: 100)
    if user.avatar.attached?
      image_tag user.avatar.variant(resize: "#{size}x#{size}")
    else
      image_tag 'defaultuser.png', width: "#{size}px"
    end
  end
end
