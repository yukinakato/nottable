class PagesController < ApplicationController
  def home
    if user_signed_in?
      @notes = current_user.notes
      @bookmarked_notes = current_user.bookmarked_notes
    else
      @user = User.new
    end
  end
end
