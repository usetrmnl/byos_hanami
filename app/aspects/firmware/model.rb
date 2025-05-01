# auto_register: false
# frozen_string_literal: true

module Terminus
  module Aspects
    module Firmware
      # Models firmware information.
      Model = Data.define :path, :uri, :version do
        def initialize(path: nil, uri: nil, version: nil) = super
      end
    end
  end
end
