class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # もしユーザーが退会していた場合はルートにリダイレクト
    @user = User.find(params[:followed_id])
    redirect_to root_path and return if @user.nil?
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    # もしユーザーが退会していた場合はルートにリダイレクト
    relationship = Relationship.find(params[:id])
    redirect_to root_path and return if relationship.nil?
    @user = relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
