class AddUiDsToFolderAndFileEntry < ActiveRecord::Migration[8.0]
  def change
    add_column :folders, :uid, :string, null: false
    add_column :file_entries, :uid, :string, null: false
    add_column :users, :uid, :string, null: false
  end
end
