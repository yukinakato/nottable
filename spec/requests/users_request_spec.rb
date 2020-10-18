require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "リダイレクトのテスト" do
    subject { response.status }

    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context "ログイン時マイページ" do
      before do
        sign_in user
        get user_path(user)
      end

      it { is_expected.to eq 200 }
    end

    context "ログイン時他人のページ" do
      before do
        sign_in user
        get user_path(other_user)
      end

      it { is_expected.to eq 200 }
    end

    context "非ログイン時" do
      before do
        get user_path(other_user)
      end

      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end
