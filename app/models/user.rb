class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :folders, dependent: :destroy
  has_many :file_entries, through: :folders

  after_create :create_root_folder

  def root_folder
    @root_folder ||= folders.find_by!(name: "My Files", parent_id: nil)
  end

  private

  def create_root_folder
    folders.create!(name: "My Files") unless folders.exists?(name: "My Files", parent_id: nil)
  end
end
