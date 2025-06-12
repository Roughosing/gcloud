module FileEntriesHelper
  include FileTypeMappable

  def preview_partial_for(file_entry)
    type = map_content_type(file_entry.content_type, {
      image: "image_preview",
      pdf: "pdf_preview",
      video: "video_preview",
      audio: "audio_preview",
      default: "fallback_preview"
    })

    "file_entries/content_preview_types/#{type}"
  end
end
