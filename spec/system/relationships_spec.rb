require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  describe "フォローボタンが表示されているかのテスト" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      sign_in user
    end

    context "自分のプロフィールページの場合" do
      it "フォローボタンは表示されていない" do
        visit user_path(user)
        expect(page).not_to have_css ".follow-form"
      end
    end

    context "他人のプロフィールページの場合" do
      it "フォローボタンが表示されている" do
        visit user_path(other_user)
        expect(page).to have_css ".follow-form"
      end
    end
  end

  describe "フォローアンフォローの操作テスト" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      sign_in user
      visit user_path(other_user)
    end

    it "フォロー状態に応じてボタン内容が変わる" do
      find(".follow-form").click
      expect(page).to have_css ".stop-follow"
      find(".follow-form").click
      expect(page).to have_css ".not-following"
    end
  end
end
