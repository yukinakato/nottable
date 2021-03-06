require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "ユーザープロフィールページの表示内容テスト" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:my_note_public) { create(:note, user: user, private: false) }
    let!(:my_note_private) { create(:note, user: user, private: true) }
    let!(:other_user_note_public) { create(:note, user: other_user, private: false) }
    let!(:other_user_note_private) { create(:note, user: other_user, private: true) }

    before do
      sign_in user
    end

    context "自分のプロフィール" do
      before do
        visit user_path(user)
      end

      it "名前、自己紹介が表示されている" do
        expect(page).to have_content user.display_name
        expect(page).to have_content user.introduce
      end

      it "公開ノートが表示されている" do
        expect(page).to have_content my_note_public.title
      end

      it "プライベートノートが表示されている" do
        expect(page).to have_content my_note_private.title
      end
    end

    context "他人のプロフィール" do
      before do
        visit user_path(other_user)
      end

      it "名前、自己紹介が表示されている" do
        expect(page).to have_content other_user.display_name
        expect(page).to have_content other_user.introduce
      end

      it "公開ノートが表示されている" do
        expect(page).to have_content other_user_note_public.title
      end

      it "プライベートノートは表示されていない" do
        expect(page).not_to have_content other_user_note_private.title
      end
    end
  end

  describe "フォロー管理画面の表示内容テスト" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      sign_in user
    end

    it "フォローするとフォロー管理画面に表示される" do
      visit following_path
      expect(page).to have_content "まだ誰もフォローしていません"

      visit user_path(other_user)
      find(".follow-form").click

      visit following_path
      expect(page).to have_content other_user.display_name
      expect(page).to have_content other_user.introduce
    end
  end
end
