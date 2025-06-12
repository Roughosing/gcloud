require 'rails_helper'

RSpec.describe FileTypeMappable do
  let(:dummy_class) do
    Class.new do
      include FileTypeMappable
      attr_accessor :content_type
      def initialize(content_type)
        @content_type = content_type
      end
    end
  end

  describe "#map_content_type" do
    subject { dummy_class.new(content_type) }

    let(:mapping) do
      {
        image: "image_preview",
        pdf: "pdf_preview",
        video: "video_preview",
        audio: "audio_preview",
        default: "fallback_preview"
      }
    end

    context "with image content type" do
      let(:content_type) { "image/jpeg" }
      it { expect(subject.map_content_type(content_type, mapping)).to eq("image_preview") }

      context "with multiple slashes" do
        let(:content_type) { "image/svg+xml/something" }
        it { expect(subject.map_content_type(content_type, mapping)).to eq("image_preview") }
      end
    end

    context "with PDF content type" do
      let(:content_type) { "application/pdf" }
      it { expect(subject.map_content_type(content_type, mapping)).to eq("pdf_preview") }
    end

    context "with video content type" do
      let(:content_type) { "video/mp4" }
      it { expect(subject.map_content_type(content_type, mapping)).to eq("video_preview") }
    end

    context "with audio content type" do
      let(:content_type) { "audio/mpeg" }
      it { expect(subject.map_content_type(content_type, mapping)).to eq("audio_preview") }
    end

    context "with unknown content type" do
      let(:content_type) { "text/plain" }
      it { expect(subject.map_content_type(content_type, mapping)).to eq("fallback_preview") }
    end

    context "with empty content type" do
      let(:content_type) { "" }
      it { expect(subject.map_content_type(content_type, mapping)).to eq("fallback_preview") }
    end

    context "with nil content type" do
      let(:content_type) { nil }
      it { expect(subject.map_content_type(content_type, mapping)).to eq("fallback_preview") }
    end
  end
end
