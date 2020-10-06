class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    bookmark = current_user.bookmarks.build(bookmark_params)
    @note = Note.find(bookmark.note_id)
    if bookmark.save
      # 自分で自分のコンテンツにいいねした時は通知を作成しない
      # if current_user.id != @note.user_id
      #   Notification.create(user_id: @note.user_id, entity: bookmark)
      # end
      # respond_to do |format|
      #   format.html { redirect_to note_path(@note) }
      #   format.js
      # end
      redirect_to note_path(@note)
      @notes = current_user.notes
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
    bookmark = Bookmark.find(params[:id])
    if bookmark&.user_id == current_user.id # 自分のいいねなら削除できる
      bookmark.destroy
      @note = bookmark.note
      redirect_to note_path(@note)
      # respond_to do |format|
      #   format.html { redirect_to note_path(@note) }
      #   format.js
      # end
    else
      # いいねの削除に失敗（投稿が削除されていた時など）
      redirect_to root_path
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:user_id, :note_id)
  end
end
