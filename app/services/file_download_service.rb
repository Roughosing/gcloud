class FileDownloadService
  def initialize(file_entry)
    @file_entry = file_entry
  end

  def call
    return failure_response unless @file_entry.file.attached?

    success_response
  rescue ActiveStorage::FileNotFoundError
    failure_response
  end

  private

  def success_response
    {
      status: :success,
      data: @file_entry.file.download,
      filename: @file_entry.name,
      content_type: @file_entry.content_type
    }
  end

  def failure_response
    {
      status: :error,
      message: "File is no longer available"
    }
  end
end
