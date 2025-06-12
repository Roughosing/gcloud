class AddUidReferencesToFileEntries < ActiveRecord::Migration[7.0]
  def up
    add_column :file_entries, :folder_uid, :string
    add_column :file_entries, :user_uid, :string

    # Backfill the UID references
    FileEntry.find_each do |file_entry|
      folder = Folder.find_by(id: file_entry.folder_id)
      user = folder&.user

      if folder && user
        file_entry.update_columns(
          folder_uid: folder.uid,
          user_uid: user.uid
        )
      end
    end

    # Add NOT NULL constraints after backfilling
    change_column_null :file_entries, :folder_uid, false
    change_column_null :file_entries, :user_uid, false

    # Add indexes
    add_index :file_entries, :folder_uid
    add_index :file_entries, :user_uid
    add_index :file_entries, [:folder_uid, :user_uid]
  end

  def down
    remove_index :file_entries, [:folder_uid, :user_uid]
    remove_index :file_entries, :user_uid
    remove_index :file_entries, :folder_uid

    remove_column :file_entries, :folder_uid
    remove_column :file_entries, :user_uid
  end
end
