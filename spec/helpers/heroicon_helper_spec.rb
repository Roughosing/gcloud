require 'rails_helper'

RSpec.describe HeroiconHelper, type: :helper do
  let(:file_entry) { build(:file_entry) }

  describe "#icon_for" do
    subject { helper.icon_for(file_entry) }

    context "with image content type" do
      before { allow(file_entry).to receive(:content_type).and_return("image/jpeg") }
      it { is_expected.to eq(["photo", :blue]) }
    end

    context "with PDF content type" do
      before { allow(file_entry).to receive(:content_type).and_return("application/pdf") }
      it { is_expected.to eq(["document", :green]) }
    end

    context "with video content type" do
      before { allow(file_entry).to receive(:content_type).and_return("video/mp4") }
      it { is_expected.to eq(["video-camera", :purple]) }
    end

    context "with audio content type" do
      before { allow(file_entry).to receive(:content_type).and_return("audio/mpeg") }
      it { is_expected.to eq(["musical-note", :black]) }
    end

    context "with unknown content type" do
      before { allow(file_entry).to receive(:content_type).and_return("text/plain") }
      it { is_expected.to eq("document") }
    end
  end
end
