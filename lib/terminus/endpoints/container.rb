# frozen_string_literal: true

require "containable"

module Terminus
  module Endpoints
    # Registers endpoint dependencies.
    module Container
      extend Containable

      register(:client) { API::Client.new }

      namespace :contracts do
        register :current_screen, CurrentScreen::Contract
        register :display, Display::Contract
      end

      namespace :responses do
        register :current_screen, CurrentScreen::Response
        register :display, Display::Response
      end
    end
  end
end
