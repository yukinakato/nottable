class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @notes = @user.notes
  end
end
