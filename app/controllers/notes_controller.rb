class NotesController < ApplicationController
  before_action :authenticate_user!

  def new
    @note = current_user.notes.build
    @mdn = MarkdownNote.new
  end

  def show
    @note = Note.find(params[:id])
  end

  def create
    if params[:note][:mode] == "markdown"
      @entity = MarkdownNote.new(content: params[:note][:content])
    else
      @entity = RichNote.new(content: params[:note][:content])
    end
    title = params[:note][:title]
    private = params[:note][:private] == "1"
    @note = current_user.notes.build(title: title, note_entity: @entity, private: private)
    if @entity.valid?
      if @note.save
        flash[:success] = "作成しました。"
        redirect_to @note
      else
        render new_note_path
      end
    else
      @note.valid?
      render new_note_path
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    note = Note.find(params[:id])
    note.update(title: params[:note][:title])
    note.note_entity.update(content: params[:note][:content])
    redirect_to note_path(note)
  end
  
  def destroy
    note = Note.find(params[:id])
    if note.user == current_user
      note.destroy
      redirect_to user_path(current_user)
    else
      redirect_to root_path
    end
  end
end
