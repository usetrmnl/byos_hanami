# frozen_string_literal: true

require "shrine"
require "shrine/storage/file_system"
require "terminus/lib_container"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
}

Shrine.plugin :determine_mime_type, analyzer: :marcel
Shrine.plugin :model
Shrine.plugin :store_dimensions, analyzer: :mini_magick
Shrine.plugin :validation_helpers

Shrine.logger = Terminus::LibContainer[:logger]
