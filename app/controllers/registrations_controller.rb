class RegistrationsController < Devise::RegistrationsController
  protected

  # パスワードなしでユーザー情報を更新できるようにする
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # ユーザー情報更新後は編集ページを再度表示する
  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
