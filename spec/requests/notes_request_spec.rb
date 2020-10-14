require 'rails_helper'

RSpec.describe "Notes", type: :request do
  describe "削除リクエストのテスト" do
    context "自分のノートに対するリクエスト" do
      let(:user) { create(:user) }
      let!(:note) { create(:note, user: user) }

      it "削除できる" do
        sign_in user
        expect { delete note_path(note) }.to change(Note, :count).from(1).to(0)
      end
    end

    context "他人のノートに対するリクエスト" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:note) { create(:note, user: other_user) }

      it "削除できない" do
        sign_in user
        expect { delete note_path(note) }.not_to change(Note, :count)
      end
    end

    context "非ログイン状態" do
      let!(:note) { create(:note) }

      it "削除できない" do
        expect { delete note_path(note) }.not_to change(Note, :count)
      end
    end
  end

  describe "更新リクエストのテスト" do
    context "自分のノートに対するリクエスト" do
      let(:user) { create(:user) }
      let!(:note) { create(:note, user: user, title: "before") }

      it "更新できる" do
        sign_in user
        params = { note: { title: "after" } }
        expect { patch note_path(note), params: params }.to change { note.reload.title }.from("before").to("after")
      end
    end

    context "他人のノートに対するリクエスト" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:note) { create(:note, user: other_user, title: "before") }

      it "更新できない" do
        sign_in user
        params = { note: { title: "after" } }
        expect { patch note_path(note), params: params }.not_to change { note.reload.title }
      end
    end

    context "非ログイン状態" do
      let!(:note) { create(:note) }

      it "更新できない" do
        params = { note: { title: "after" } }
        expect { patch note_path(note), params: params }.not_to change { note.reload.title }
      end
    end
  end

  describe "エディットページを開くリクエストのテスト" do
    context "自分のノートに対するリクエスト" do
      let(:user) { create(:user) }
      let!(:note) { create(:note, user: user, title: "before") }

      it "ステータスが 200 となる" do
        sign_in user
        get edit_note_path(note)
        expect(response.status).to eq 200
      end
    end

    context "他人のノートに対するリクエスト" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:note) { create(:note, user: other_user, title: "before") }

      it "ルートにリダイレクト" do
        sign_in user
        get edit_note_path(note)
        expect(response).to redirect_to root_path
      end
    end

    context "非ログイン状態" do
      let!(:note) { create(:note) }

      it "ログインページにリダイレクト" do
        get edit_note_path(note)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
