class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Folder", optional: true
  has_many :subfolders, class_name: "Folder", foreign_key: "parent_id", dependent: :destroy
  has_many :file_entries, dependent: :destroy

  validates :name, presence: true
  validate :parent_folder_belongs_to_same_user

  def self.create_with_parent(user:, params:)
    folder = user.folders.new(params)
    folder.parent = user.folders.find_by(id: params[:parent_id]) if params[:parent_id].present?
    folder
  end

  private

  def parent_folder_belongs_to_same_user
    if parent.present? && parent.user_id != user_id
      errors.add(:parent, "must belong to the same user")
    end
  end
end
