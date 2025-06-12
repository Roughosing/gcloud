module HeroiconHelper
  include Heroicon::Engine.helpers
  include FileTypeMappable

  def icon_for(file_entry)
    map_content_type(file_entry.content_type, {
      image: ["photo", :blue],
      pdf: ["document", :green],
      video: ["video-camera", :purple],
      audio: ["musical-note", :black],
      default: "document"
    })
  end
end
