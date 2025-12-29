# frozen_string_literal: true

require "refinements/pathname"

using Refinements::Pathname

Hanami.app.register_provider :i18n do
  prepare { require "i18n" }

  start do
    I18n.load_path.concat slice.root.join("config/locales").files("*.yml")
    register :i18n, I18n
  end
end
