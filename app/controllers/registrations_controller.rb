class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_action :guest_check, except: [:new, :create]
  before_action :configure_permitted_parameters

  def edit_password
    authenticate_scope!
  end

  def update_password
    update_method = current_user.from_sns ? "update" : "update_with_password"
    update_params = current_user.from_sns ? new_passwords : passwords

    if current_user.send(update_method, update_params) && current_user.update(from_sns: false)
      flash[:success] = "パスワードを変更しました"
      bypass_sign_in(current_user)
      redirect_to edit_user_registration_path
    else
      authenticate_scope!
      render "devise/registrations/edit_password"
    end
  end

  def delete_avatar
    current_user.avatar.purge
    flash[:success] = "アバターを削除しました"
    redirect_to edit_user_registration_path
  end

  protected

  # パスワードなしでユーザー情報を更新できるようにする
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # ユーザー情報更新後はユーザー情報編集ページを再度表示する
  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :display_name, :introduce])
  end

  def passwords
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def new_passwords
    params.require(:user).permit(:password, :password_confirmation)
  end

  def guest_check
    if current_user&.email == Constants::GUEST_EMAIL
      flash[:warning] = "ゲストユーザーの情報は編集できません"
      redirect_to root_path
    end
  end
end
