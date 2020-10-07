class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters  

  def edit_password
  end

  def update_password
    if current_user.valid_password?(params[:user][:current_password])
      if current_user.update(new_passwords)
        flash[:success] = "パスワードを変更しました"
        bypass_sign_in(current_user)
        redirect_to edit_user_registration_path
      else
        render 'devise/registrations/edit_password'
      end
    else
      flash.now[:danger] = "現在のパスワードが相違しています"
      render 'devise/registrations/edit_password'
    end
  end
  
  protected

  # パスワードなしでユーザー情報を更新できるようにする
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # ユーザー情報更新後は編集ページを再度表示する
  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:display_name, :introduce, :password, :password_confirmation])
  end

  def new_passwords
    params.require(:user).permit(:password, :password_confirmation)
  end
end
