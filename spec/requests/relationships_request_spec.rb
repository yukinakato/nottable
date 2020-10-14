require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "単独の削除リクエストのテスト" do
    context "自分のフォローに対するリクエスト" do
      let(:user) { create(:user) }
      let!(:relationship) { create(:relationship, follower: user) }

      it "削除できる" do
        sign_in user
        expect { delete relationship_path(relationship) }.to change(Relationship, :count).from(1).to(0)
      end
    end

    context "他人のフォローに対するリクエスト" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:relationship) { create(:relationship, follower: other_user) }

      it "削除できない" do
        sign_in user
        expect { delete relationship_path(relationship) }.not_to change(Relationship, :count)
      end
    end

    context "非ログイン状態" do
      let!(:relationship) { create(:relationship) }

      it "削除できない" do
        expect { delete relationship_path(relationship) }.not_to change(Relationship, :count)
      end
    end
  end

  describe "連続したリクエストのテスト" do
    context "すでにフォローずみの場合" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:relationship) { create(:relationship, follower: user, followed: other_user) }

      it "ユーザーパスにリダイレクト" do
        sign_in user
        params = { followed_id: other_user.id }
        post relationships_path, params: params
        expect(response).to redirect_to user_path(other_user)
      end
    end

    context "すでにフォロー解除ずみの場合" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:relationship) { create(:relationship, follower: user, followed: other_user) }

      it "ユーザーパスにリダイレクト" do
        sign_in user
        delete relationship_path(relationship)
        delete relationship_path(relationship), headers: { "HTTP_REFERER": user_path(other_user) }
        expect(response).to redirect_to user_path(other_user)
      end
    end
  end
end
