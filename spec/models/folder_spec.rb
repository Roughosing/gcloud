require 'rails_helper'

RSpec.describe Folder, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:parent).class_name("Folder").optional }
    it { should have_many(:subfolders).class_name("Folder").with_foreign_key("parent_id").dependent(:destroy) }
    it { should have_many(:file_entries).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }

    describe "parent_folder_belongs_to_same_user" do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      let(:parent_folder) { create(:folder, user: user1) }
      let(:folder) { build(:folder, user: user2, parent: parent_folder) }

      it "is invalid if parent folder belongs to different user" do
        expect(folder).not_to be_valid
        expect(folder.errors[:parent]).to include("must belong to the same user")
      end

      it "is valid if parent folder belongs to same user" do
        folder.user = user1
        expect(folder).to be_valid
      end
    end
  end

  describe ".create_with_parent" do
    let(:user) { create(:user) }
    let(:parent_folder) { create(:folder, user: user) }

    context "with parent_id" do
      let(:params) { { name: "New Folder", parent_id: parent_folder.id } }

      it "sets the parent folder" do
        folder = described_class.create_with_parent(user: user, params: params)
        expect(folder.parent).to eq(parent_folder)
      end
    end

    context "without parent_id" do
      let(:params) { { name: "New Folder" } }

      it "leaves parent as nil" do
        folder = described_class.create_with_parent(user: user, params: params)
        expect(folder.parent).to be_nil
      end
    end

    context "with invalid parent_id" do
      let(:params) { { name: "New Folder", parent_id: 999999 } }

      it "leaves parent as nil" do
        folder = described_class.create_with_parent(user: user, params: params)
        expect(folder.parent).to be_nil
      end
    end
  end
end
