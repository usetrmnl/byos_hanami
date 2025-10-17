# frozen_string_literal: true

Hanami.app.register_provider :mini_magick do
  prepare { require "mini_magick" }

  start do
    MiniMagick.configure { |config| config.logger = slice[:logger] }
    register :mini_magick, MiniMagick
  end
end
