require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  describe "通知作成のテスト" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:note) { create(:note, user: other_user) }
    let(:other_user_note) { create(:note, user: other_user) }

    before do
      sign_in user
    end

    it "フォローしたら相手に通知が作成される" do
      visit user_path(other_user)
      find(".follow-form").click
      expect(page).to have_css ".stop-follow"

      sign_out user
      sign_in other_user

      visit notifications_path
      expect(page).to have_selector ".notifications-count", text: "1"
      expect(page).to have_content "#{user.display_name} さんがあなたをフォローしました！"
    end

    it "フォローしてすぐ解除したら相手は通知を確認できない" do
      visit user_path(other_user)
      find(".follow-form").click
      expect(page).to have_css ".stop-follow"
      find(".follow-form").click
      expect(page).to have_css ".not-following"

      sign_out user
      sign_in other_user

      visit notifications_path
      expect(page).not_to have_selector ".notifications-count", text: "1"
      expect(page).to have_content "通知はありません"
    end

    it "ブックマークしたら相手に通知が作成される" do
      visit note_path(other_user_note)
      find(".bookmark-form").click
      expect(page).to have_css ".bookmarked"

      sign_out user
      sign_in other_user

      visit notifications_path
      expect(page).to have_selector ".notifications-count", text: "1"
      expect(page).to have_content "#{user.display_name} さんがあなたのノートをブックマークしました！"
    end

    it "ブックマークしてすぐ解除したら相手は通知を確認できない" do
      visit note_path(other_user_note)
      find(".bookmark-form").click
      expect(page).to have_css ".bookmarked"
      find(".bookmark-form").click
      expect(page).to have_css ".not-bookmarked"

      sign_out user
      sign_in other_user

      visit notifications_path
      expect(page).not_to have_selector ".notifications-count", text: "1"
      expect(page).to have_content "通知はありません"
    end

    it "ノートを作成したらフォロワーに通知が作成される" do
      other_user.follow(user)

      visit new_note_path
      click_on "新規ノート"
      fill_in "タイトル", with: "title"
      fill_in "内容", with: "content"
      click_on "作成"

      sign_out user
      sign_in other_user

      visit notifications_path
      expect(page).to have_selector ".notifications-count", text: "1"
      expect(page).to have_content "#{user.display_name} さんがノートを作成しました！"
      expect(page).to have_content "title"
    end

    it "プライベートノートを作成してもフォロワーに通知が作成されない" do
      other_user.follow(user)

      visit new_note_path
      click_on "新規ノート"
      fill_in "タイトル", with: "title"
      fill_in "内容", with: "content"
      check 'プライベートにする'
      click_on "作成"

      sign_out user
      sign_in other_user

      visit notifications_path
      expect(page).not_to have_selector ".badge"
      expect(page).to have_content "通知はありません。"
    end

    it "自分で自分のノートをブックマークしても通知は作られない" do
      visit notifications_path
      expect(page).to have_content "通知はありません。"

      visit note_path(note)
      find(".bookmark-form").click

      visit notifications_path
      expect(page).not_to have_selector ".badge"
      expect(page).to have_content "通知はありません。"
    end
  end
end
