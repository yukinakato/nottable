require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  describe "単独の削除リクエストのテスト" do
    context "自分のブックマークに対するリクエスト" do
      let(:user) { create(:user) }
      let!(:bookmark) { create(:bookmark, user: user) }

      it "削除できる" do
        sign_in user
        expect { delete bookmark_path(bookmark) }.to change(Bookmark, :count).from(1).to(0)
      end
    end

    context "他人のブックマークに対するリクエスト" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:bookmark) { create(:bookmark, user: other_user) }

      it "削除できない" do
        sign_in user
        expect { delete bookmark_path(bookmark) }.not_to change(Bookmark, :count)
      end
    end

    context "非ログイン状態" do
      let!(:bookmark) { create(:bookmark) }

      it "削除できない" do
        expect { delete bookmark_path(bookmark) }.not_to change(Bookmark, :count)
      end
    end
  end

  describe "連続したリクエストのテスト" do
    context "すでにブックマークずみの場合" do
      let(:user) { create(:user) }
      let(:note) { create(:note) }
      let!(:bookmark) { create(:bookmark, user: user, note: note) }

      it "ノートパスにリダイレクト" do
        sign_in user
        params = { bookmark: { user_id: user.id, note_id: note.id } }
        post bookmarks_path, params: params
        expect(response).to redirect_to note_path(note)
      end
    end

    context "すでにブックマーク解除ずみの場合" do
      let(:user) { create(:user) }
      let(:note) { create(:note) }
      let!(:bookmark) { create(:bookmark, user: user, note: note) }

      it "ノートパスにリダイレクト" do
        sign_in user
        delete bookmark_path(bookmark)
        delete bookmark_path(bookmark), headers: { "HTTP_REFERER": note_path(note) }
        expect(response).to redirect_to note_path(note)
      end
    end
  end
end
