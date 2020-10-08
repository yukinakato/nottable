class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # もしユーザーが退会していた場合はルートにリダイレクト
    target_user = User.find_by(id: params[:followed_id])
    if target_user.nil?
      redirect_to root_path
      return 
    end
    relation = Relationship.create(follower: current_user, followed: target_user)
    # フォローした相手に対して通知を作成
    target_user.notifications.create(notify_entity: relation)
    respond_to do |format|
      format.html { redirect_to target_user }
      format.js
    end
  end

  def destroy
    relationship = Relationship.find_by(id: params[:id])
    # 相手ユーザーが退会していた場合や、フォロワーが自分でない場合はルートにリダイレクト
    if relationship.nil? || relationship.follower != current_user
      redirect_to root_path
      return 
    end
    target_user = relationship.followed
    current_user.unfollow(target_user)
    respond_to do |format|
      format.html { redirect_to target_user }
      format.js
    end
  end
end
