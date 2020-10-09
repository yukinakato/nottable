class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :owner_check, only: [:edit, :update, :destroy]

  def new
    @notes = current_user.notes
    @bookmarked_notes = current_user.bookmarked_notes #_filtered
    @note = Note.new
  end

  def show
    # このような設定はAjaxモードでは不要になる
    @notes = current_user.notes
    @bookmarked_notes = current_user.bookmarked_notes
    @note = Note.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @entity = if params[:note][:mode] == "markdown"
                MarkdownNote.new(content: params[:note][:content])
              else
                RichNote.new(content: params[:note][:content])
              end
    title = params[:note][:title]
    private = params[:note][:private] == "1"
    @note = current_user.notes.build(title: title, note_entity: @entity, private: private)
    if @entity.valid?
      if @note.save
        # プライベートノートでなければフォロワーに対して通知を作成
        unless private
          current_user.followers.each do |follower|
            follower.notifications.create(user: follower, notify_entity: @note)
          end
        end
        flash[:success] = "作成しました。"
        redirect_to @note
      else
        @notes = current_user.notes
        render new_note_path
      end
    else
      @note.valid?
      @notes = current_user.notes
      render new_note_path
    end
  end

  def edit
    @notes = current_user.notes
    @bookmarked_notes = current_user.bookmarked_notes
  end

  def update
    title = params[:note][:title]
    private = params[:note][:private] == "1"
    # 失敗をハンドリングしてください
    @note.update(title: title, private: private)
    @note.note_entity.update(content: params[:note][:content])
    redirect_to note_path(@note)
  end
  
  def destroy
    @note.destroy
    redirect_to root_path
  end

  def search
    @searchkey = params[:searchkey]
    @my_notes_result = Note.search(@searchkey).where(user: current_user)
    @other_users_notes_result = Note.search(@searchkey).where.not(user: current_user).no_private
    render 'notes/search'
  end

  def create_pdf
    @note = Note.find(params[:id])
    render pdf: "download", template: 'notes/pdf'
    # response.headers["Content-Disposition"] = "attachment"
  end

  private

  def owner_check
    @note = Note.find(params[:id])
    redirect_to root_path if current_user != @note.user
  end
end
