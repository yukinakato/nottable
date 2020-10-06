class NotesController < ApplicationController
  before_action :authenticate_user!

  def new
    @notes = current_user.notes
    @note = Note.new
    @bookmarked_notes = current_user.bookmarked_notes
  end

  def show
    @notes = current_user.notes
    @note = Note.find(params[:id])
    @bookmarked_notes = current_user.bookmarked_notes
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
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def create_pdf
    @note = Note.find(params[:id])
    render pdf: "download", template: 'notes/pdf'
    # response.headers["Content-Disposition"] = "attachment"
  end
end
