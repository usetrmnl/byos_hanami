# frozen_string_literal: true

Hanami.app.register_provider :mini_magick do
  prepare { require "mini_magick" }

  start { MiniMagick.configure { |config| config.logger = Terminus::LibContainer[:logger] } }
end
