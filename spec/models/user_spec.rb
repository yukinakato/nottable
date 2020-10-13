require 'rails_helper'

RSpec.describe User, type: :model do
  describe "表示名のバリデーションテスト" do
    subject { user }

    context "表示名なし" do
      let(:user) { build(:user, display_name: "") }

      it { is_expected.not_to be_valid }
    end

    context "表示名 nil" do
      let(:user) { build(:user, display_name: nil) }

      it { is_expected.not_to be_valid }
    end

    context "表示名あり(文字数制限以下)" do
      let(:user) { build(:user, display_name: "name") }

      it { is_expected.to be_valid }
    end

    context "表示名あり(文字数制限超え)" do
      let(:user) { build(:user, display_name: "a" * (Constants::USER_DISPLAY_NAME_MAX_LENGTH + 1)) }

      it { is_expected.not_to be_valid }
    end
  end

  describe "自己紹介のバリデーションテスト" do
    subject { user }

    context "自己紹介なし" do
      let(:user) { build(:user, introduce: "") }

      it { is_expected.to be_valid }
    end

    context "自己紹介 nil" do
      let(:user) { build(:user, introduce: nil) }

      it { is_expected.to be_valid }
    end

    context "自己紹介あり(文字数制限以下)" do
      let(:user) { build(:user, introduce: "hello") }

      it { is_expected.to be_valid }
    end

    context "自己紹介あり(文字数制限超え)" do
      let(:user) { build(:user, introduce: "a" * (Constants::USER_INTRODUCE_MAX_LENGTH + 1)) }

      it { is_expected.not_to be_valid }
    end
  end

  describe "ブックマーク関連メソッドのテスト" do
    let(:user) { create(:user) }
    let(:note) { create(:note, :markdown) }

    it "ブックマークに追加・削除" do
      user.bookmark(note)
      expect(user.reload.bookmarked_notes).to include(note)
      expect(user.reload.bookmarked?(note)).to be_truthy

      user.unbookmark(note)
      expect(user.reload.bookmarked_notes).not_to include(note)
      expect(user.reload.bookmarked?(note)).to be_falsey
    end
  end

  describe "フォロー関連メソッドのテスト" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "フォロー・アンフォロー（する側）" do
      user.follow(other_user)
      expect(user.reload.following).to include(other_user)
      expect(user.reload.following?(other_user)).to be_truthy

      user.unfollow(other_user)
      expect(user.reload.following).not_to include(other_user)
      expect(user.reload.following?(other_user)).to be_falsey
    end

    it "フォロー・アンフォロー（される側）" do
      user.follow(other_user)
      expect(other_user.reload.followers).to include(user)

      user.unfollow(other_user)
      expect(other_user.reload.followers).not_to include(user)
    end
  end

  describe "通知関連メソッドのテスト" do
    let(:user) { create(:user) }

    it "unread_notifications_length メソッド" do
      expect { create(:notification, :for_follow, user: user) }.to change(user, :unread_notifications_length).from(0).to(1)
    end
  end

  describe "ノート関連メソッドのテスト" do
    subject { user.prohibited?(note) }

    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context "自分のノート・公開の時" do
      let(:note) { create(:note, :markdown, user: user, private: false) }

      it { is_expected.to be_falsey }
    end

    context "自分のノート・非公開の時" do
      let(:note) { create(:note, :markdown, user: user, private: true) }

      it { is_expected.to be_falsey }
    end

    context "他人のノート・公開の時" do
      let(:note) { create(:note, :markdown, user: other_user, private: false) }

      it { is_expected.to be_falsey }
    end

    context "他人のノート・非公開の時" do
      let(:note) { create(:note, :markdown, user: other_user, private: true) }

      it { is_expected.to be_truthy }
    end
  end

  describe "ユーザー削除時のデータ削除テスト" do
    let(:user) { create(:user) }

    it "ノートが削除される" do
      create(:note, :markdown, user: user)
      expect { user.destroy }.to change(Note, :count).from(1).to(0)
    end

    it "ブックマークが削除される" do
      create(:bookmark, user: user)
      expect { user.destroy }.to change(Bookmark, :count).from(1).to(0)
    end

    it "relationships が削除される" do
      create(:relationship, follower: user)
      expect { user.destroy }.to change(Relationship, :count).from(1).to(0)
    end

    it "通知が削除される" do
      create(:notification, :for_follow, user: user)
      expect { user.destroy }.to change(Notification, :count).from(1).to(0)
    end
  end
end
