require 'rails_helper'

RSpec.describe "System", type: :system do
  describe "表示内容のテスト" do
    let(:user) { create(:user, email: "user@example.com", password: "password", display_name: "Alice") }
    let(:guest) { create(:user, email: Constants::GUEST_EMAIL, password: "password", display_name: "Guest") }

    before do
      visit root_path
    end

    it "非ログイン状態でのルートにアクセス" do
      expect(page).to have_content "新規登録"
    end

    it "正しい情報でログイン、ログアウト動作" do
      user
      fill_in "メールアドレス", with: "user@example.com"
      fill_in "パスワード", with: "password"
      click_on "ログイン"

      expect(page).to have_content "ログインしました"
      expect(page).to have_content "Alice"
      sleep 5
      expect(page).not_to have_content "ログインしました"

      click_on "Alice"
      click_on "ログアウト"
      expect(page).not_to have_content "Alice"
      expect(page).to have_content "ログアウトしました"
      sleep 5
      expect(page).not_to have_content "ログアウトしました"
    end

    it "ゲストでログイン、ログアウト動作" do
      guest
      click_on "今すぐお試し（ゲストでログイン）"

      expect(page).to have_content "ログインしました"
      expect(page).to have_content "Guest"
      sleep 5
      expect(page).not_to have_content "ログインしました"

      click_on "Guest"
      click_on "ログアウト"
      expect(page).not_to have_content "Guest"
      expect(page).to have_content "ログアウトしました"
      sleep 5
      expect(page).not_to have_content "ログアウトしました"
    end

    it "誤った情報でログイン" do
      fill_in "メールアドレス", with: "bademail"
      fill_in "パスワード", with: "badpassword"
      click_on "ログイン"

      expect(current_path).to eq new_user_session_path
    end
  end
end
