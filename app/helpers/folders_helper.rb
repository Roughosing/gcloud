module FoldersHelper
  def breadcrumb_path(folder)
    return [] if folder.nil?

    path = []
    while folder
      path.unshift(folder)
      folder = folder.parent
    end
    path
  end
end
