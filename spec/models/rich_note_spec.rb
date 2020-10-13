require 'rails_helper'

RSpec.describe RichNote, type: :model do
  let(:rich_note) { create(:rich_note) }

  it "factory is valid" do
    expect(rich_note).to be_valid
  end
end
