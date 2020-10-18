require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "存在のバリデーションテスト" do
    subject { relationship }

    let(:follower) { create(:user) }
    let(:followed) { create(:user) }

    context "フォロワー、フォロイーが存在する時" do
      let(:relationship) { build(:relationship, follower: follower, followed: followed) }

      it { is_expected.to be_valid }
    end

    context "フォロワーしか存在しない時" do
      let(:relationship) { build(:relationship, follower: follower, followed: nil) }

      it { is_expected.not_to be_valid }
    end

    context "フォロイーしか存在しない時" do
      let(:relationship) { build(:relationship, followed: followed, follower: nil) }

      it { is_expected.not_to be_valid }
    end

    context "フォロワーもフォロイーも存在しない時" do
      let(:relationship) { build(:relationship, followed: nil, follower: nil) }

      it { is_expected.not_to be_valid }
    end
  end

  describe "フォロー関係の重複ができないことのテスト" do
    let(:follower) { create(:user) }
    let(:followed) { create(:user) }

    it "データベースのユニーク制約エラーが発生する" do
      create(:relationship, follower: follower, followed: followed)
      expect { create(:relationship, follower: follower, followed: followed) }.to raise_error ActiveRecord::RecordNotUnique
    end
  end

  describe "フォロー解除時のデータ削除テスト" do
    let(:relationship) { create(:relationship) }

    it "関連する通知が削除される" do
      create(:notification, notify_entity: relationship)
      expect { relationship.destroy }.to change(Notification, :count).from(1).to(0)
    end
  end
end
