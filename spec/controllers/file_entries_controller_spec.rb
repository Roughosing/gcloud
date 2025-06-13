require 'rails_helper'

RSpec.describe FileEntriesController, type: :controller do
  include_context 'with authenticated user'
  render_views

  let(:folder) { user.root_folder }
  let(:file) { create(:file_entry, :image, folder: folder) }
  let(:test_file) { fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpeg') }

  describe "GET #show" do
    before do
      file
      get :show, params: { folder_id: folder.uid, id: file.uid }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "assigns the requested file entry" do
      expect(assigns(:file_entry)).to eq(file)
    end

    it "assigns the folder" do
      expect(assigns(:folder)).to eq(folder)
    end

    describe "page content" do
      it "displays the file name" do
        expect(response.body).to have_selector("turbo-frame#modal") do
          expect(response.body).to have_selector("h3", text: file.name)
          expect(response.body).to have_selector("p", text: file.content_type)
          expect(response.body).to have_selector("p", text: file.size)
        end
      end
    end

    context "when file entry is not found" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get :show, params: { folder_id: folder.uid, id: "invalid" }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when folder is not found" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get :show, params: { folder_id: "invalid", id: file.uid }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST #create" do
    context "with valid file" do
      before { post :create, params: { folder_id: folder.uid, file_entry: { file: test_file } } }

      it "creates a new file" do
        expect(FileEntry.count).to eq(1)
      end

      it "redirects to the folder" do
        expect(response).to redirect_to(folder_path(folder))
      end

      it "displays a success message" do
        expect(flash[:notice]).to eq("File was successfully uploaded.")
      end
    end

    context "with invalid file" do
      it "displays an error message if the file is not valid" do
        post :create, params: { folder_id: folder.uid, file_entry: { file: nil } }
        expect(flash[:alert]).to eq("Error uploading file: Name can't be blank, File can't be blank")
      end

      it "does not create a new file" do
        expect(FileEntry.count).to eq(0)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when deletion succeeds" do
      before { delete :destroy, params: { folder_id: folder.uid, id: file.uid } }

      it "deletes the file" do
        expect(FileEntry.count).to eq(0)
      end

      it "redirects to the folder" do
        expect(response).to redirect_to(folder_path(folder))
      end

      it "displays a success message" do
        expect(flash[:notice]).to eq("File was successfully deleted.")
      end
    end

    context "when deletion fails" do
      before do
        errors = double(full_messages: ["Cannot delete file"])
        file_instance = user.file_entries.find_by!(uid: file.uid)
        allow(file_instance).to receive(:destroy).and_return(false)
        allow(file_instance).to receive(:errors).and_return(errors)
        allow(user.file_entries).to receive(:find_by!).with(uid: file.uid).and_return(file_instance)

        delete :destroy, params: { folder_id: folder.uid, id: file.uid }
      end

      it "does not delete the file" do
        expect(FileEntry.count).to eq(1)
      end

      it "redirects back to the folder" do
        expect(response).to redirect_to(folder_path(folder))
      end

      it "displays an error message" do
        expect(flash[:alert]).to eq("Error deleting file: Cannot delete file")
      end
    end
  end

  describe "GET #download" do
    context "when file exists and is attached" do
      let(:success_response) do
        {
          status: :success,
          data: file.file.download,
          filename: file.name,
          content_type: file.content_type
        }
      end

      before do
        allow_any_instance_of(FileDownloadService).to receive(:call).and_return(success_response)
        get :download, params: { folder_id: folder.uid, id: file.uid }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "sends the file with correct headers" do
        expect(response.headers["Content-Type"]).to eq(file.content_type)
        expect(response.headers["Content-Disposition"]).to include(file.name)
      end
    end

    context "when file is not available" do
      let(:error_response) do
        {
          status: :error,
          message: "File is no longer available"
        }
      end

      before do
        allow_any_instance_of(FileDownloadService).to receive(:call).and_return(error_response)
        get :download, params: { folder_id: folder.uid, id: file.uid }
      end

      it "redirects to folder with not found status" do
        expect(response.status).to eq(404)
      end

      it "sets flash alert" do
        expect(flash[:alert]).to eq("File is no longer available")
      end
    end

    context "when file entry is not found" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get :download, params: { folder_id: folder.uid, id: "invalid" }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when folder is not found" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get :download, params: { folder_id: "invalid", id: file.uid }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
