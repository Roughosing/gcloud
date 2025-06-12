class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_folder, only: [:show, :destroy]

  def index
    redirect_to folder_path(current_user.root_folder)
  end

  def show
    @subfolders = @folder.subfolders
    @files = @folder.file_entries
  end

  def new
    @folder = current_user.folders.new(parent_id: params[:parent_id])
    @parent_folder = get_parent_folder
  end

  def create
    @folder = Folder.create_with_parent(user: current_user, params: folder_params)

    if @folder.save
      redirect_to folder_path(@folder), notice: "Folder was successfully created."
    else
      redirect_to folder_path(get_parent_folder), alert: "Error creating folder: #{@folder.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    if @folder.destroy
      redirect_to folder_path(get_parent_folder), notice: "Folder was successfully deleted."
    else
      redirect_to folder_path(@folder), alert: "Error deleting folder: #{@folder.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_folder
    @folder = current_user.folders.find_by!(uid: params[:id])
  end

  def get_parent_folder
    @folder.parent || current_user.root_folder
  end

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
