# frozen_string_literal: true

require "hanami"
require "petail"

require_relative "initializers/rack_attack"

module Terminus
  # The application base configuration.
  class App < Hanami::App
    # :nocov:
    RubyVM::YJIT.enable if defined? RubyVM::YJIT
    # :nocov:
    Dry::Schema.load_extensions :monads
    Dry::Validation.load_extensions :monads

    prepare_container do |container|
      container.config.component_dirs.dir "app" do |dir|
        dir.memoize = -> component { component.key.start_with? "repositories." }
      end
    end

    config.inflections { it.acronym "BMP", "HTML", "IP", "PNG" }

    config.actions
          .formats
          .add(:all, "application/octet-stream")
          .add(:all, "*/*")
          .add :problem_details, Petail::MEDIA_TYPE_JSON

    config.actions.content_security_policy.then do |csp|
      csp[:manifest_src] = "'self'"
      csp[:script_src] += " 'unsafe-eval' 'unsafe-inline' https://unpkg.com/"
    end

    config.middleware.use Rack::Attack
    config.middleware.use Rack::Deflater
    config.middleware.use :body_parser, :json

    environment :development do
      # :nocov:
      config.logger.options[:colorize] = true

      config.logger = config.logger.instance.add_backend(
        colorize: false,
        stream: root.join("log/development.log")
      )
      # :nocov:
    end
  end
end
