module FileTypeMappable
  extend ActiveSupport::Concern

  def map_content_type(content_type, mapping)
    return mapping[:default] if content_type.nil? || content_type.empty?

    case
    when content_type.start_with?("image/")
      mapping[:image]
    when content_type == "application/pdf"
      mapping[:pdf]
    when content_type.start_with?("video/")
      mapping[:video]
    when content_type.start_with?("audio/")
      mapping[:audio]
    else
      mapping[:default]
    end
  end
end
