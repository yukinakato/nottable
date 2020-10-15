require 'rails_helper'

RSpec.describe "Bookmarks", type: :system do
  describe "表示内容のテスト" do
    let(:user) { create(:user, display_name: "Alice") }
    let(:markdown_note_1) { create(:markdown_note, content: "hello") }
    let(:markdown_note_2) { create(:markdown_note, content: "goodbye") }
    let!(:note_1) { create(:note, title: "test_title_1", user: user, note_entity: markdown_note_1) }
    let!(:note_2) { create(:note, title: "test_title_2", user: user, note_entity: markdown_note_2) }

    before do
      sign_in user
      visit root_path
    end

    it "ブックマーク追加・削除すると左ペインにも反映される" do
      within "#mynotes" do
        click_on "test_title_1"
      end

      within ".right-pane" do
        find(".not-bookmarked").click
        expect(page).to have_css ".bookmarked"
      end

      find("#bookmarks-tab").click
      within "#bookmarks" do
        expect(page).to have_content "test_title_1"
      end

      within ".right-pane" do
        find(".bookmarked").click
        expect(page).to have_css ".not-bookmarked"
      end

      find("#bookmarks-tab").click
      within "#bookmarks" do
        expect(page).not_to have_content "test_title_1"
      end
    end
  end
end
