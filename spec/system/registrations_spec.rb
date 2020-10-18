require 'rails_helper'

RSpec.describe "Registrations", type: :system do
  describe "ユーザー情報を更新するテスト" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit edit_user_registration_path
    end

    it "情報を更新できる" do
      fill_in "メールアドレス", with: "my_new_address@example.com"
      fill_in "ニックネーム", with: "my new name"
      fill_in "自己紹介", with: "my new introduction"
      click_button "更新"

      expect(page).to have_content "アカウント情報を変更しました"
      user.reload
      expect(user.email).to eq "my_new_address@example.com"
      expect(user.display_name).to eq "my new name"
      expect(user.introduce).to eq "my new introduction"
    end
  end

  describe "パスワードを更新するテスト" do
    let(:user) { create(:user, password: "before") }

    before do
      sign_in user
      visit users_edit_password_path
    end

    it "情報を更新できる" do
      new_password = "newpassword"
      fill_in "現在のパスワード", with: "before"
      fill_in "新しいパスワード", with: new_password
      fill_in "新しいパスワード（確認）", with: new_password
      click_button "更新"

      expect(page).to have_content "パスワードを変更しました"
      user.reload
      expect(user.valid_password?(new_password)).to be_truthy
    end
  end

  describe "ゲストユーザーの情報が更新できないことのテスト" do
    let(:user) { create(:user, email: Constants::GUEST_EMAIL) }

    before do
      sign_in user
    end

    it "ユーザー情報編集ページを開けない" do
      visit edit_user_registration_path
      expect(page).to have_content "ゲストユーザーの情報は編集できません"
      expect(current_path).to eq root_path
    end

    it "パスワード更新ページを開けない" do
      visit users_edit_password_path
      expect(page).to have_content "ゲストユーザーの情報は編集できません"
      expect(current_path).to eq root_path
    end
  end
end
