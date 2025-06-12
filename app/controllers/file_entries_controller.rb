class FileEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_folder, only: [:show, :create, :destroy]
  before_action :set_file_entry, only: [:show, :destroy]

  def show
  end

  def create
    @file_entry = @folder.file_entries.new(file_entry_params)

    if @file_entry.save
      redirect_to folder_path(@folder), notice: "File was successfully uploaded."
    else
      redirect_to folder_path(@folder), alert: "Error uploading file: #{@file_entry.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    if @file_entry.destroy
      redirect_to folder_path(@folder), notice: "File was successfully deleted."
    else
      redirect_to folder_path(@folder), alert: "Error deleting file: #{@file_entry.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_file_entry
    @file_entry = current_user.file_entries.find_by!(uid: params[:id])
  end

  def set_folder
    @folder = current_user.folders.find_by!(uid: params[:folder_id])
  end

  def file_entry_params
    params.require(:file_entry).permit(:file)
  end
end
