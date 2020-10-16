class SessionsController < Devise::SessionsController
  def guest_sign_in
    guest_user = User.find_by(email: Constants::GUEST_EMAIL)
    sign_in guest_user
    flash[:success] = "ゲストユーザーとしてログインしました。"
    redirect_to root_path
  end
end
