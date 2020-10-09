class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def edit_password
    authenticate_scope!
  end

  def update_password
    if current_user.update_with_password(passwords)
      flash[:success] = "パスワードを変更しました"
      bypass_sign_in(current_user)
      redirect_to edit_user_registration_path
    else
      authenticate_scope!
      render 'devise/registrations/edit_password'
    end
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
    devise_parameter_sanitizer.permit(:account_update, keys: [:display_name, :introduce, :password, :password_confirmation])
  end

  def passwords
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
