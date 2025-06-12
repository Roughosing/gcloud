class CreateFileEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :file_entries do |t|
      t.string :name
      t.string :content_type
      t.bigint :size
      t.references :folder, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
