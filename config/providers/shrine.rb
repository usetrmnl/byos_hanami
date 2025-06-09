# frozen_string_literal: true

Hanami.app.register_provider :shrine do
  prepare do
    require "shrine"
    require "shrine/storage/file_system"
  end

  start do
    Shrine.storages = {
      cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
      store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
    }

    Shrine.plugin :determine_mime_type, analyzer: :marcel
    Shrine.plugin :entity
    Shrine.plugin :store_dimensions, analyzer: :mini_magick
    Shrine.plugin :validation_helpers

    Shrine.logger = Terminus::LibContainer[:logger]

    register :shrine, Shrine
  end
end
