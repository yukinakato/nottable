require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "タイトルのバリデーションテスト" do
    subject { note }

    let(:user) { create(:user) }

    context "タイトルがない時" do
      let(:note) { build(:note, user: user, title: "") }

      it { is_expected.not_to be_valid }
    end

    context "タイトルが nil の時" do
      let(:note) { build(:note, user: user, title: nil) }

      it { is_expected.not_to be_valid }
    end

    context "タイトルがある時（文字数制限にかからない）" do
      let(:note) { build(:note, user: user, title: "a" * Constants::NOTE_TITLE_MAX_LENGTH) }

      it { is_expected.to be_valid }
    end

    context "タイトルがある時（文字数制限オーバー）" do
      let(:note) { build(:note, user: user, title: "a" * (Constants::NOTE_TITLE_MAX_LENGTH + 1)) }

      it { is_expected.not_to be_valid }
    end
  end

  describe "ユーザーの有無のバリデーションテスト" do
    subject { note }

    let(:user) { create(:user) }

    context "ユーザーが存在しない時" do
      let(:note) { build(:note, user: nil) }

      it { is_expected.not_to be_valid }
    end

    context "ユーザーが存在する時" do
      let(:note) { build(:note, user: user) }

      it { is_expected.to be_valid }
    end
  end

  describe "entity の有無のバリデーションテスト" do
    subject { note }

    let(:user) { create(:user) }

    context "マークダウンノートがある時" do
      let(:note) { build(:note, :markdown, user: user) }

      it { is_expected.to be_valid }
    end

    context "リッチテキストノートがある時" do
      let(:note) { build(:note, :richnote, user: user) }

      it { is_expected.to be_valid }
    end

    context "entity がない時" do
      let(:note) { build(:note, note_entity: nil, user: user) }

      it { is_expected.not_to be_valid }
    end
  end

  describe "no_private メソッドのテスト" do
    let!(:note_public) { create(:note) }
    let!(:note_private) { create(:note, private: true) }

    it "プライベートノートを含まない" do
      expect(Note.no_private).to contain_exactly(note_public)
    end
  end

  describe "search メソッドのテスト" do
    subject { Note.search(keyword) }

    let(:markdown_1) { create(:markdown_note, content: "aaa") }
    let(:markdown_2) { create(:markdown_note, content: "bbb") }
    let(:markdown_3) { create(:markdown_note, content: "cbc") }
    let!(:note_1) { create(:note, note_entity: markdown_1) }
    let!(:note_2) { create(:note, note_entity: markdown_2) }
    let!(:note_3) { create(:note, note_entity: markdown_3) }

    context "空のとき" do
      let(:keyword) { nil }

      it { is_expected.to contain_exactly(note_1, note_2, note_3) }
    end

    context "空のとき" do
      let(:keyword) { "" }

      it { is_expected.to contain_exactly(note_1, note_2, note_3) }
    end

    context "a のとき" do
      let(:keyword) { "a" }

      it { is_expected.to contain_exactly(note_1) }
    end

    context "b のとき" do
      let(:keyword) { "b" }

      it { is_expected.to contain_exactly(note_2, note_3) }
    end

    context "z のとき" do
      let(:keyword) { "z" }

      it { is_expected.to be_empty }
    end
  end
end
