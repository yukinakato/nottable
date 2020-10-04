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
      let(:user) { build(:user, display_name: "a" * 51) }

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
      let(:user) { build(:user, introduce: "a" * 101) }

      it { is_expected.not_to be_valid }
    end
  end
end
