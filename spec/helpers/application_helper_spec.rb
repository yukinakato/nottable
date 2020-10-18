require 'rails_helper'

RSpec.describe "ApplicationHelper", type: :helper do
  include ApplicationHelper

  describe "full_title のテスト" do
    subject { full_title(page_title: page_title) }

    context "引数がある時" do
      let(:page_title) { "Specific Title" }

      it { is_expected.to eq "Specific Title | #{Constants::SITE_NAME}" }
    end

    context "引数が空白の時" do
      let(:page_title) { "   " }

      it { is_expected.to eq Constants::SITE_NAME }
    end

    context "引数が nil の時" do
      let(:page_title) { nil }

      it { is_expected.to eq Constants::SITE_NAME }
    end

    context "引数が無い時" do
      it { expect(full_title).to eq Constants::SITE_NAME }
    end
  end
end
