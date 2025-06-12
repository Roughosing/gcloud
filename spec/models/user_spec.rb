require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:folders).dependent(:destroy) }
    it { should have_many(:file_entries).through(:folders) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end

  describe "callbacks" do
    describe "after_create :create_root_folder" do
      let(:user) { create(:user) }

      it "creates a root folder named 'My Files'" do
        expect(user.folders.count).to eq(1)
        expect(user.folders.first.name).to eq("My Files")
        expect(user.folders.first.parent).to be_nil
      end

      it "doesn't create duplicate root folders" do
        user.send(:create_root_folder)
        expect(user.folders.count).to eq(1)
      end
    end
  end

  describe "#root_folder" do
    let(:user) { create(:user) }

    it "returns the root folder" do
      expect(user.root_folder.name).to eq("My Files")
      expect(user.root_folder.parent).to be_nil
    end

    it "memoizes the result" do
      first_call = user.root_folder
      second_call = user.root_folder
      expect(first_call.object_id).to eq(second_call.object_id)
    end
  end
end
