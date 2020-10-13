require 'rails_helper'

RSpec.describe MarkdownNote, type: :model do
  describe "記事の文字数のバリデーションテスト" do
    subject { markdown_note }

    context "内容が空の時" do
      let(:markdown_note) { build(:markdown_note, content: "") }

      it { is_expected.to be_valid }
    end

    context "内容が nil の時" do
      let(:markdown_note) { build(:markdown_note, content: nil) }

      it { is_expected.to be_valid }
    end

    context "内容がある時（文字数制限にかからない）" do
      let(:markdown_note) { build(:markdown_note, content: "a" * Constants::NOTE_CONTENT_MAX_LENGTH) }

      it { is_expected.to be_valid }
    end

    context "内容がある時（文字数制限オーバー）" do
      let(:markdown_note) { build(:markdown_note, content: "a" * (Constants::NOTE_CONTENT_MAX_LENGTH + 1)) }

      it { is_expected.not_to be_valid }
    end
  end
end
