# frozen_string_literal: true

Hanami.app.register_provider :http do
  prepare { require "http" }

  start do
    HTTP.default_options = HTTP::Options.new features: {logging: {logger: slice[:logger]}}
    register :http, HTTP
  end
end
