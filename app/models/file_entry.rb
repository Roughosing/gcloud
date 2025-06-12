class FileEntry < ApplicationRecord
  belongs_to :folder
  belongs_to :user

  has_one_attached :file

  validates :name, presence: true
  validates :file, presence: true
  validates :folder, presence: true
  validates :user, presence: true

  before_validation :set_metadata, on: :create, if: -> { file.attached? }
  before_validation :set_user, on: :create, if: -> { folder.present? && folder.user.present? }
  before_validation :set_uids, on: :create, if: -> { folder.present? && user.present? }

  private

  def set_metadata
    self.name ||= file.filename.to_s
    self.content_type = file.content_type
    self.size = file.byte_size
  end

  def set_user
    self.user = folder.user
  end

  def set_uids
    self.folder_uid = folder.uid
    self.user_uid = user.uid
  end
end
