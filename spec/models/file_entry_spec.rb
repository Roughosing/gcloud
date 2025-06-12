require 'rails_helper'

RSpec.describe FileEntry, type: :model do
  let(:user) { create(:user) }
  let(:folder) { create(:folder, user: user) }

  describe "associations" do
    it { should belong_to(:folder) }
    it { should belong_to(:user) }
    it { should have_one_attached(:file) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:file) }
    it { should validate_presence_of(:folder) }
    it { should validate_presence_of(:user) }
  end

  describe "callbacks" do
    describe "before_validation on create" do
      describe "#set_metadata" do
        let(:file_entry) { build(:file_entry, folder: folder, user: user) }

        it "sets name from filename if not provided" do
          file_entry.name = nil
          file_entry.valid?
          expect(file_entry.name).to eq(file_entry.file.filename.to_s)
        end

        it "sets content type from file" do
          file_entry.valid?
          expect(file_entry.content_type).to eq(file_entry.file.content_type)
        end

        it "sets size from file" do
          file_entry.valid?
          expect(file_entry.size).to eq(file_entry.file.byte_size)
        end

        it "doesn't set metadata if file is not attached" do
          file_entry = build(:file_entry, :without_file, folder: folder, user: user)
          file_entry.valid?
          expect(file_entry.content_type).to be_nil
          expect(file_entry.size).to be_nil
        end
      end

      describe "#set_user" do
        let(:file_entry) { build(:file_entry, folder: folder, user: nil) }

        it "sets user from folder" do
          file_entry.valid?
          expect(file_entry.user).to eq(folder.user)
        end

        it "doesn't set user if folder is missing" do
          file_entry.folder = nil
          file_entry.valid?
          expect(file_entry.user).to be_nil
        end

        it "doesn't set user if folder.user is missing" do
          allow(folder).to receive(:user).and_return(nil)
          file_entry.valid?
          expect(file_entry.user).to be_nil
        end
      end

      describe "#set_uids" do
        let(:file_entry) { build(:file_entry, folder: folder, user: user) }

        it "sets folder_uid and user_uid" do
          file_entry.valid?
          expect(file_entry.folder_uid).to eq(folder.uid)
          expect(file_entry.user_uid).to eq(user.uid)
        end

        it "doesn't set uids if folder is missing" do
          file_entry.folder = nil
          file_entry.valid?
          expect(file_entry.folder_uid).to be_nil
          expect(file_entry.user_uid).to be_nil
        end

        it "doesn't set uids if user is missing" do
          file_entry.user = nil
          file_entry.folder = nil
          file_entry.valid?
          expect(file_entry.folder_uid).to be_nil
          expect(file_entry.user_uid).to be_nil
        end
      end
    end
  end
end
