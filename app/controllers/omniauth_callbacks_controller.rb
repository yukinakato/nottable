class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
  skip_before_action :verify_authenticity_token, only: :facebook

  def facebook
    auth = request.env["omniauth.auth"].except("extra")
    @user = User.from_omniauth(auth)

    if @user.persisted?
      flash[:success] = "Facebookでログインしました。"
      sign_in_and_redirect @user
    else
      flash[:warning] = "ユーザー登録に失敗しました。管理者にお問い合わせ下さい。"
      redirect_to root_path
    end
  end

  # 認証キャンセルした時
  def failure
    redirect_to root_path
  end
end
