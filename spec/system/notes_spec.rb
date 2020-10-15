require 'rails_helper'

RSpec.describe "Notes", type: :system do
  describe "表示内容のテスト" do
    let(:user) { create(:user, display_name: "Alice") }
    let(:markdown_note_1) { create(:markdown_note, content: "content1") }
    let(:markdown_note_2) { create(:markdown_note, content: "content2") }
    let!(:note_1) { create(:note, title: "test_title_1", user: user, note_entity: markdown_note_1) }
    let!(:note_2) { create(:note, title: "test_title_2", user: user, note_entity: markdown_note_2) }

    before do
      sign_in user
      visit root_path
    end

    it "左ペインのノートタイトルをクリックすると内容が表示される" do
      within "#mynotes" do
        click_on "test_title_1"
      end

      expect(current_path).to eq note_path(note_1)
      within ".right-pane" do
        expect(page).to have_content "Alice"
        expect(page).to have_content "content1"
      end

      within "#mynotes" do
        click_on "test_title_2"
      end

      expect(current_path).to eq note_path(note_2)
      within ".right-pane" do
        expect(page).not_to have_content "content1"
        expect(page).to have_content "content2"
      end
    end

    it "編集ボタンをクリックすると編集画面が表示される" do
      within "#mynotes" do
        click_on "test_title_1"
      end

      within ".right-pane" do
        find(".note-edit-icon").click
      end

      expect(current_path).to eq edit_note_path(note_1)
      expect(page).to have_content "更新"
    end

    it "新規ノートをクリックすると新規作成画面が表示される" do
      click_on "新規ノート"
      expect(current_path).to eq new_note_path
      expect(page).to have_content "マークダウンモード"
      expect(page).to have_button "作成"
    end
  end

  describe "ノート作成、更新、削除" do
    let(:user) { create(:user, display_name: "Alice") }
    let(:note) { create(:note, user: user, title: "title") }

    before do
      sign_in user
      visit root_path
    end

    it "ノート作成" do
      click_on "新規ノート"
      fill_in "タイトル", with: "title"
      fill_in "内容", with: "content1"
      click_on "作成"

      within ".right-pane" do
        expect(page).to have_content "作成者"
        expect(page).to have_content "Alice"
        expect(page).to have_content "title"
        expect(page).to have_content "content1"
        expect(page).to have_css ".not-bookmarked"
        expect(page).to have_css ".note-edit-icon"
      end
    end

    it "ノート更新" do
      visit note_path(note)
      find(".note-edit-icon").click
      fill_in "内容", with: "content2"
      click_on "更新"

      within ".right-pane" do
        expect(page).to have_content "作成者"
        expect(page).to have_content "Alice"
        expect(page).to have_content "title"
        expect(page).not_to have_content "content1"
        expect(page).to have_content "content2"
      end
    end

    it "ノート削除" do
      visit note_path(note)
      find(".note-edit-icon").click
      page.accept_confirm do
        click_on "削除"
      end
      within "#mynotes" do
        expect(page).not_to have_content "test_title"
      end
      expect(current_path).to eq root_path
    end
  end

  describe "他人のノートを表示" do
    let(:user) { create(:user, display_name: "Alice") }
    let(:other_user) { create(:user, display_name: "Bob") }

    before do
      sign_in user
      visit note_path(note)
    end

    context "公開ノートの場合" do
      let(:markdown_note) { create(:markdown_note, content: "public") }
      let(:note) { create(:note, user: other_user, title: "title", note_entity: markdown_note) }

      it "編集ボタンが表示されていない" do
        within ".right-pane" do
          expect(page).to have_content "public"
          expect(page).not_to have_css ".note-edit-icon"
        end
      end
    end

    context "非公開ノートの場合" do
      let(:markdown_note) { create(:markdown_note, content: "secret") }
      let(:note) { create(:note, user: other_user, title: "title", note_entity: markdown_note, private: true) }

      it "編集ボタンが表示されていない" do
        within ".right-pane" do
          expect(page).not_to have_css ".note-edit-icon"
        end
      end

      it "PDFダウンロードリンクが表示されていない" do
        within ".right-pane" do
          expect(page).not_to have_css ".pdf-download-button"
        end
      end

      it "内容が秘匿されている" do
        within ".right-pane" do
          expect(page).not_to have_content "secret"
          expect(page).to have_content "プライベートに設定されました"
        end
      end
    end
  end
end
