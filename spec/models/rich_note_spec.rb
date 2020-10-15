require 'rails_helper'

RSpec.describe RichNote, type: :model do
  let(:rich_note) { create(:rich_note) }

  it "factory is valid" do
    expect(rich_note).to be_valid
  end

  describe "削除時の Note 削除テスト" do
    let(:rich_note) { create(:rich_note) }
    let!(:note) { create(:note, note_entity: rich_note) }

    it "Note が削除される" do
      expect { rich_note.destroy }.to change(Note, :count).from(1).to(0)
    end
  end
end
