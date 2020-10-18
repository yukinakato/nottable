class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    bookmark = current_user.bookmarks.build(bookmark_params)
    @note = Note.find_by(id: bookmark.note_id)
    if @note.nil? # 投稿が削除されている
      redirect_to root_path
      return
    end
    unless current_user.bookmarks.find_by(bookmark_params) # すでにブックマーク済みではない
      bookmark.save
      # 自分で自分のノートをブックマークした時は通知を作成しない
      if current_user != @note.user
        Notification.find_or_create_by(user_id: @note.user_id, notify_entity: bookmark)
      end
    end
    respond_to do |format|
      format.html { redirect_to @note }
      format.js
    end
  end

  def destroy
    bookmark = Bookmark.find_by(id: params[:id])
    if bookmark.nil? || bookmark.user != current_user
      note = Note.find_by(id: params[:note][:note_id])
      if note
        redirect_to note
      else
        redirect_to root_path
      end
      return
    end
    @note = bookmark.note
    current_user.unbookmark(@note)
    respond_to do |format|
      format.html { redirect_to @note }
      format.js
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :note_id)
  end
end
