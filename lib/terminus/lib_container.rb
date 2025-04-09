# frozen_string_literal: true

require "cogger"
require "containable"
require "http"

module Terminus
  # Registers application dependencies.
  module LibContainer
    extend Containable

    register :http do
      HTTP.default_options = ::HTTP::Options.new features: {logging: {logger: self[:logger]}}
      HTTP
    end

    register(:logger) { Cogger.new id: :terminus, formatter: :json }
  end
end
