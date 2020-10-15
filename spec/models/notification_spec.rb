require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "ユーザーの有無のバリデーションテスト" do
    subject { notification }

    let(:user) { create(:user) }

    context "ユーザーが存在しない時" do
      let(:notification) { build(:notification, user: nil) }

      it { is_expected.not_to be_valid }
    end

    context "ユーザーが存在する時" do
      let(:notification) { build(:notification, user: user) }

      it { is_expected.to be_valid }
    end
  end

  describe "entity の有無のバリデーションテスト" do
    subject { notification }

    let(:user) { create(:user) }

    context "ノート作成に対する通知の時" do
      let(:notification) { build(:notification, :for_note, user: user) }

      it { is_expected.to be_valid }
    end

    context "フォローに対する通知の時" do
      let(:notification) { build(:notification, :for_follow, user: user) }

      it { is_expected.to be_valid }
    end

    context "ブックマークに対する通知の時" do
      let(:notification) { build(:notification, :for_bookmark, user: user) }

      it { is_expected.to be_valid }
    end

    context "entity がない時" do
      let(:notification) { build(:notification, notify_entity: nil, user: user) }

      it { is_expected.not_to be_valid }
    end
  end

  describe "通知を削除しても実体は削除されないことのテスト" do
    context "ノートの通知の場合" do
      let(:note) { create(:note) }
      let!(:notification) { create(:notification, notify_entity: note) }

      it "ノートは削除されない" do
        expect { notification.destroy }.not_to change(Note, :count)
      end
    end

    context "ブックマークの通知の場合" do
      let(:bookmark) { create(:bookmark) }
      let!(:notification) { create(:notification, notify_entity: bookmark) }

      it "ブックマークは削除されない" do
        expect { notification.destroy }.not_to change(Note, :count)
      end
    end

    context "フォローの通知の場合" do
      let(:relationship) { create(:relationship) }
      let!(:notification) { create(:notification, notify_entity: relationship) }

      it "フォロー関係は削除されない" do
        expect { notification.destroy }.not_to change(Note, :count)
      end
    end
  end

  describe "latest スコープのテスト" do
    it "最新順に並び替えられる" do
      n_1 = create(:notification)
      n_2 = create(:notification)
      n_3 = create(:notification)
      expect(Notification.latest).to eq [n_3, n_2, n_1]
    end
  end
end
