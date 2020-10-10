class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :owner_check, only: [:edit, :update, :destroy]
  after_action :disable_cache, only: [:show, :edit]

  def new
    @note = Note.new
    set_notes_and_bookmarks
  end

  def show
    @note = Note.find(params[:id])
    respond_to do |format|
      format.js
      format.html do
        set_notes_and_bookmarks
      end
    end
  end

  def create
    @entity = if param_mode_markdown?
                MarkdownNote.new(content: param_content)
              else
                RichNote.new(content: param_content)
              end
    @note = current_user.notes.build(title: param_title, note_entity: @entity, private: param_private?)
    @note.valid? # 先にエラーメッセージを格納する
    if @entity.valid? && @note.save
      # プライベートノートでなければフォロワーに対して通知を作成
      unless param_private?
        current_user.followers.each do |follower|
          follower.notifications.create(user: follower, notify_entity: @note)
        end
      end
      flash[:success] = "作成しました。"
      redirect_to @note
    else
      set_notes_and_bookmarks
      render 'notes/new'
    end
  end

  def edit
    respond_to do |format|
      format.js
      format.html do
        set_notes_and_bookmarks
      end
    end
  end

  def update
    if @note.update(title: param_title, private: param_private?) && @note.note_entity.update(content: param_content)
      flash[:success] = "保存しました。"
      redirect_to note_path(@note)
    else
      set_notes_and_bookmarks
      render 'notes/edit'
    end
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
    if current_user.prohibited?(@note)
      # 他人のプライベートノートはダウンロードできない
      flash[:danger] = "このノートはプライベートに設定されています"
      redirect_to @note
      return
    end
    render pdf: "download", template: 'notes/pdf'
    # response.headers["Content-Disposition"] = "attachment"
  end

  private

  def owner_check
    @note = Note.find(params[:id])
    redirect_to root_path if current_user != @note.user
  end

  # 非 Ajax ページから Ajax したページにブラウザバックした時の対策
  def disable_cache
    response.headers["Cache-Control"] = "no-store"
  end

  def set_notes_and_bookmarks
    @notes = current_user.notes
    @bookmarked_notes = current_user.bookmarked_notes
  end

  def param_mode_markdown?
    params[:note][:mode] == "markdown"
  end

  def param_title
    params[:note][:title]
  end

  def param_private?
    params[:note][:private] == "1"
  end

  def param_content
    params[:note][:content]
  end
end
