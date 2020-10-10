class NotificationsController < ApplicationController
  before_action :authenticate_user!
  after_action :mark_read_all, only: :show

  def show
    @notifications = current_user.notifications.includes(notify_entity: [user: :avatar_attachment]).latest
  end

  def destroy
    current_user.notifications.delete_all
    redirect_to notifications_path
  end

  private

  def mark_read_all
    @notifications.update_all(unread: false)
  end
end
