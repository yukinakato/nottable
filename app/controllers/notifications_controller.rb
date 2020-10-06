class NotificationsController < ApplicationController
  before_action :authenticate_user!
  after_action :mark_read_all, only: :show

  def show
    @notifications = current_user.notifications.latest
    @notes = current_user.notes
    @bookmarked_notes = current_user.bookmarked_notes
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
