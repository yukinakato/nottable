class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @notes = if @user == current_user
               @user.notes.includes(note_entity: :rich_text_content)
             else
               @user.notes.includes(note_entity: :rich_text_content).no_private
             end
  end
end
