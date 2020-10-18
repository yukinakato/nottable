require 'rails_helper'

RSpec.describe "Bookmarks", type: :system do
  describe "操作と動的な表示のテスト" do
    let(:user) { create(:user) }
    let(:markdown_note) { create(:markdown_note) }
    let!(:note) { create(:note, user: user, note_entity: markdown_note) }

    before do
      sign_in user
      visit root_path
    end

    it "ブックマーク追加・削除すると左ペインにも反映される" do
      within "#mynotes" do
        click_on note.title
      end

      within ".right-pane" do
        find(".not-bookmarked").click
        expect(page).to have_css ".bookmarked"
      end

      find("#bookmarks-tab").click
      within "#bookmarks" do
        expect(page).to have_content note.title
      end

      within ".right-pane" do
        find(".bookmarked").click
        expect(page).to have_css ".not-bookmarked"
      end

      find("#bookmarks-tab").click
      within "#bookmarks" do
        expect(page).not_to have_content note.title
      end
    end
  end
end
