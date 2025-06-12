require 'rails_helper'

RSpec.describe FoldersHelper, type: :helper do
  describe "#breadcrumb_path" do
    let(:user) { create(:user) }
    let(:root_folder) { user.root_folder }
    let(:parent_folder) { create(:folder, parent: root_folder, user: user) }
    let(:child_folder) { create(:folder, parent: parent_folder, user: user) }

    it "returns an array containing only the folder when it has no parent" do
      expect(helper.breadcrumb_path(root_folder)).to eq([root_folder])
    end

    it "returns an array with the folder and its parent" do
      expect(helper.breadcrumb_path(parent_folder)).to eq([root_folder, parent_folder])
    end

    it "returns an array with the complete path from root to the folder" do
      expect(helper.breadcrumb_path(child_folder)).to eq([root_folder, parent_folder, child_folder])
    end

    it "handles nil folder" do
      expect(helper.breadcrumb_path(nil)).to eq([])
    end
  end
end
