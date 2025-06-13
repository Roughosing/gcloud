require 'rails_helper'

RSpec.describe FileDownloadService do
  let(:user) { create(:user) }
  let(:folder) { user.root_folder }
  let(:file_entry) { create(:file_entry, :image, folder: folder) }
  let(:service) { described_class.new(file_entry) }

  describe "#call" do
    context "when file is attached" do
      it "returns success response with file data" do
        result = service.call

        expect(result[:status]).to eq(:success)
        expect(result[:data]).to eq(file_entry.file.download)
        expect(result[:filename]).to eq(file_entry.name)
        expect(result[:content_type]).to eq(file_entry.content_type)
      end
    end

    context "when file storage raises error" do
      before do
        allow_any_instance_of(ActiveStorage::Blob).to receive(:download).and_raise(ActiveStorage::FileNotFoundError)
      end

      it "returns error response" do
        result = service.call

        expect(result[:status]).to eq(:error)
        expect(result[:message]).to eq("File is no longer available")
      end
    end
  end
end
