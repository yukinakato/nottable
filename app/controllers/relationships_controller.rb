class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find_by(id: params[:followed_id])
    if @user.nil? # ユーザーが退会している
      redirect_to root_path
      return
    end
    unless Relationship.find_by(follower: current_user, followed: @user) # すでにフォロー済みではない
      relation = Relationship.new(follower: current_user, followed: @user)
      # フォローした相手に対して通知を作成
      @user.notifications.create(notify_entity: relation)
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    relationship = Relationship.find_by(id: params[:id])
    if relationship.nil? || relationship.follower != current_user
      user = User.find_by(id: params[:user][:user_id])
      if user
        redirect_to user
      else
        redirect_to root_path
      end
      return
    end
    @user = relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
