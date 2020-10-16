require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "ユーザー情報の更新テスト" do
    let(:guest_user) { create(:user, email: Constants::GUEST_EMAIL, password: "password") }
    let(:normal_user) { create(:user, email: "before@example.com", password: "password") }

    context "通常ユーザーの場合" do
      before do
        sign_in normal_user
      end

      it "プロフィール情報を更新できる" do
        params = { user: { email: "after@example.com" } }
        patch user_registration_path, params: params
        expect(response).to redirect_to edit_user_registration_path
        expect(normal_user.reload.email).to eq "after@example.com"
      end

      it "パスワードを更新できる" do
        params = { user: { current_password: "password", password: "newpassword", password_confirmation: "newpassword" } }
        patch users_edit_password_path, params: params
        expect(response).to redirect_to edit_user_registration_path
        expect(normal_user.reload.valid_password?("newpassword")).to be_truthy
      end
    end

    context "ゲストユーザーの場合" do
      before do
        sign_in guest_user
      end

      it "プロフィール情報を更新できない" do
        params = { user: { email: "after@example.com" } }
        patch user_registration_path, params: params
        expect(response).to redirect_to root_path
        expect(guest_user.reload.email).to eq Constants::GUEST_EMAIL
      end

      it "パスワードを更新できない" do
        params = { user: { current_password: "password", password: "newpassword", password_confirmation: "newpassword" } }
        patch users_edit_password_path, params: params
        expect(response).to redirect_to root_path
        expect(guest_user.reload.valid_password?("password")).to be_truthy
      end
    end

    context "非ログイン時" do
      it "ログイン画面にリダイレクトされる" do
        params = { user: { email: "after@example.com" } }
        patch user_registration_path, params: params
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
