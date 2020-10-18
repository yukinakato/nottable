require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe "存在のバリデーションテスト" do
    subject { bookmark }

    context "ユーザー、ノートが存在する時" do
      let(:user) { create(:user) }
      let(:note) { create(:note) }
      let(:bookmark) { build(:bookmark, user: user, note: note) }

      it { is_expected.to be_valid }
    end

    context "ユーザーしか存在しない時" do
      let(:user) { create(:user) }
      let(:bookmark) { build(:bookmark, note: nil) }

      it { is_expected.not_to be_valid }
    end

    context "ノートしか存在しない時" do
      let(:note) { create(:note) }
      let(:bookmark) { build(:bookmark, user: nil) }

      it { is_expected.not_to be_valid }
    end

    context "ユーザーもノートも存在しない時" do
      let(:bookmark) { build(:bookmark, user: nil, note: nil) }

      it { is_expected.not_to be_valid }
    end
  end

  describe "ブックマークの重複ができないことのテスト" do
    let(:user) { create(:user) }
    let(:note) { create(:note) }

    it "データベースのユニーク制約エラーが発生する" do
      create(:bookmark, user: user, note: note)
      expect { create(:bookmark, user: user, note: note) }.to raise_error ActiveRecord::RecordNotUnique
    end
  end

  describe "ブックマーク解除時のデータ削除テスト" do
    let(:bookmark) { create(:bookmark) }

    it "関連する通知が削除される" do
      create(:notification, notify_entity: bookmark)
      expect { bookmark.destroy }.to change(Notification, :count).from(1).to(0)
    end
  end
end
