class PagesController < ApplicationController
  def home
    @user = User.new
  end

  def terms
  end
end
