require 'rails_helper'

RSpec.describe FoldersController, type: :controller do
  include_context 'with authenticated user'
  render_views

  let(:folder) { user.root_folder }
  let(:subfolder) { create(:folder, parent: folder, user: user) }
  let(:file) { create(:file_entry, folder: folder) }

  describe "GET #index" do
    before { get :index }

    it "redirects to the root folder" do
      expect(response).to redirect_to(folder_path(user.root_folder))
    end
  end

  describe "GET #show" do
    before do
      subfolder
      file
      get :show, params: { id: folder.uid }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    describe "page content" do
      it "displays the folder name" do
        expect(response.body).to include(folder.name)
      end

      it "displays the folder name in an h1 tag" do
        expect(response.body).to have_selector('h1', text: folder.name)
      end

      it "displays subfolders" do
        expect(response.body).to have_selector("#folder-#{subfolder.id}", count: 1)
        expect(response.body).to have_selector("#folder-#{subfolder.id}", text: subfolder.name)
      end

      it "displays files" do
        expect(response.body).to have_selector("#file-entry-#{file.id}", count: 1)
        expect(response.body).to have_selector("#file-entry-#{file.id}", text: file.name)
      end
    end

    describe "GET #new" do
      before { get :new }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      describe "page content" do
        it "displays the new folder form" do
          expect(response.body).to have_selector("h2", text: "Create new folder")
          expect(response.body).to have_selector("p", text: "Add a new folder to organize your files")
          expect(response.body).to have_selector("form[action='/folders'][method='post']")
          expect(response.body).to have_selector("input[name='folder[name]']")
          expect(response.body).to have_selector("input[type='submit'][value='Create Folder']")
          expect(response.body).to have_selector("a[href='#{folder_path(folder)}']", text: "Cancel")
        end
      end
    end

    describe "POST #create" do
      before do
        post :create, params: { folder: { name: "Test Folder" } }
      end

      it "creates a new folder" do
        expect(Folder.count).to eq(3)
      end

      it "redirects to the new folder" do
        expect(response).to redirect_to(folder_path(Folder.last))
      end

      it "displays a success message" do
        expect(flash[:notice]).to eq("Folder was successfully created.")
      end

      it "displays an error message if the folder name is blank" do
        post :create, params: { folder: { name: "" } }
        expect(response).to redirect_to(folder_path(folder))
        expect(flash[:alert]).to eq("Error creating folder: Name can't be blank")
      end
    end

    describe "DELETE #destroy" do
      context "when deletion succeeds" do
        before { delete :destroy, params: { id: subfolder.uid } }

        it "deletes the folder" do
          expect(Folder.count).to eq(1)
        end

        it "redirects to the parent folder" do
          expect(response).to redirect_to(folder_path(folder))
        end

        it "displays a success message" do
          expect(flash[:notice]).to eq("Folder was successfully deleted.")
        end
      end

      context "when deletion fails" do
        before do
          errors = double(full_messages: ["Cannot delete folder"])
          folder_instance = user.folders.find_by!(uid: subfolder.uid)
          allow(folder_instance).to receive(:destroy).and_return(false)
          allow(folder_instance).to receive(:errors).and_return(errors)
          allow(user.folders).to receive(:find_by!).with(uid: subfolder.uid).and_return(folder_instance)

          delete :destroy, params: { id: subfolder.uid }
        end

        it "does not delete the folder" do
          expect(Folder.count).to eq(2)
        end

        it "redirects back to the folder" do
          expect(response).to redirect_to(folder_path(subfolder))
        end

        it "displays an error message" do
          expect(flash[:alert]).to eq("Error deleting folder: Cannot delete folder")
        end
      end

      context "when folder is not found" do
        it "displays an error message" do
          expect {
            delete :destroy, params: { id: "invalid" }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
