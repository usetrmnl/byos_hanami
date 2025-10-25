# frozen_string_literal: true

require "cogger"

module Terminus
  module Aspects
    module Logging
      # Adapts Cogger Rack middleware for provider registration.
      module Adapter
        module_function

        def with logger
          @logger = logger
          self
        end

        def new application
          @application = Cogger::Rack::Logger.new application, {logger: @logger}
        end

        def call(environment) = @application.call environment
      end
    end
  end
end
