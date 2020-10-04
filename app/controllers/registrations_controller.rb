class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters  
  
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
  end
end
