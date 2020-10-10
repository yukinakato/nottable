class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    bookmark = current_user.bookmarks.build(bookmark_params)
    @note = Note.find_by(id: bookmark.note_id)
    if bookmark.save
      # 自分で自分のコンテンツにいいねした時は通知を作成しない
      if current_user != @note.user
        Notification.create(user_id: @note.user_id, notify_entity: bookmark)
      end
      respond_to do |format|
        format.html { redirect_to note_path(@note) }
        format.js
      end
    else
      if @note.nil?
        # いいねに失敗（投稿が削除されていて見つからなかった）
        redirect_to root_path
      else
        # いいねに失敗（すでにいいねしていた）
        redirect_to note_path(@note)
      end
    end
  end

  def destroy
    # 別タブでいいね解除をした場合、bookmark が nil になってしまいルートに飛んでしまう
    bookmark = Bookmark.find_by(id: params[:id])
    if bookmark.nil? || bookmark.user != current_user
      redirect_to root_path
      return
    end
    @note = bookmark.note
    current_user.unbookmark(@note)
    respond_to do |format|
      format.html { redirect_to note_path(@note) }
      format.js
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :note_id)
  end
end
