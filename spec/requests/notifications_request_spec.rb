require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  describe "削除リクエストのテスト" do
    context "自分の通知に対するリクエスト" do
      let(:user) { create(:user) }
      let!(:notification) { create(:notification, user: user) }

      it "削除できる" do
        sign_in user
        expect { delete notifications_path }.to change(Notification, :count).from(1).to(0)
      end
    end

    context "他人の通知に対するリクエスト" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:notification) { create(:notification, user: other_user) }

      it "削除できない" do
        sign_in user
        expect { delete notifications_path }.not_to change(Notification, :count)
      end
    end

    context "非ログイン状態" do
      let!(:notification) { create(:notification) }

      it "削除できない" do
        expect { delete notifications_path }.not_to change(Notification, :count)
      end
    end
  end
end
