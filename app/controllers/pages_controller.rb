class PagesController < ApplicationController
  def home
    if user_signed_in?
      @notes = current_user.notes
      # @bookmarks = current_user.bookmarks
    else
      @user = User.new
    end
  end

  def terms
  end
end
