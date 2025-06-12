class BackfillUids < ActiveRecord::Migration[7.0]
  def up
    Folder.find_each do |folder|
      folder.update_column(:uid, SecureRandom.uuid) unless folder.uid.present?
    end

    FileEntry.find_each do |file_entry|
      file_entry.update_column(:uid, SecureRandom.uuid) unless file_entry.uid.present?
    end

    User.find_each do |user|
      user.update_column(:uid, SecureRandom.uuid) unless user.uid.present?
    end

    add_index :folders, :uid, unique: true
    add_index :file_entries, :uid, unique: true
    add_index :users, :uid, unique: true
  end

  def down
    remove_index :folders, :uid
    remove_index :file_entries, :uid
    remove_index :users, :uid
  end
end
