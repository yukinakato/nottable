require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe "存在のバリデーションテスト" do
    subject { bookmark }

    context "ユーザー、ノートが存在する時" do
      let(:bookmark) { build(:bookmark) }

      it { is_expected.to be_valid }
    end

    context "ユーザーしか存在しない時" do
      let(:bookmark) { build(:bookmark, note: nil) }

      it { is_expected.not_to be_valid }
    end

    context "ノートしか存在しない時" do
      let(:bookmark) { build(:bookmark, user: nil) }

      it { is_expected.not_to be_valid }
    end

    context "ユーザーもノートも存在しない時" do
      let(:bookmark) { build(:bookmark, user: nil, note: nil) }

      it { is_expected.not_to be_valid }
    end
  end
end
