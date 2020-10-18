require 'rails_helper'

RSpec.describe "LoginLogout", type: :system do
  describe "ログイン動作のテスト" do
    let(:user) { create(:user, email: "user@example.com", password: "password", display_name: "Alice") }
    let(:guest) { create(:user, email: "guest@example.com", password: "password", display_name: "Guest") }

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

      within ".nav-item.dropdown" do
        click_on "Alice"
        click_on "ログアウト"
      end
      expect(page).not_to have_content "Alice"
      expect(page).to have_content "ログアウトしました"
      sleep 5
      expect(page).not_to have_content "ログアウトしました"
    end

    it "ゲストでログイン、ログアウト動作" do
      guest
      click_on "今すぐお試し（ゲストでログイン）"

      expect(page).to have_content "ゲストユーザーとしてログインしました"
      expect(page).to have_content "Guest"
      sleep 5
      expect(page).not_to have_content "ゲストユーザーとしてログインしました"

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

  describe "サインアップのテスト" do
    it "不備なくサインアップできる" do
      visit root_path
      within ".login-form" do
        click_link "新規登録"
      end

      fill_in "ニックネーム", with: "nickname"
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "password"
      click_button "登録"

      expect(page).to have_content "アカウント登録が完了しました"
      expect(page).to have_content "まだノートを作成していません"
      expect(page).to have_content "nickname"
    end

    it "不備がありサインアップできない" do
      visit root_path
      within ".login-form" do
        click_link "新規登録"
      end

      click_button "登録"

      expect(page).to have_content "メールアドレスを入力してください"
      expect(page).to have_content "パスワードを入力してください"
      expect(page).to have_content "ニックネームを入力してください"
    end
  end
end
