class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @notes = if @user == current_user
               @user.notes
             else
               @user.notes.no_private
             end
  end
end
