# auto_register: false
# frozen_string_literal: true

module Terminus
  module Aspects
    module Firmware
      # Models firmware information.
      Model = Data.define :path, :size, :uri, :version do
        def initialize(path: nil, size: 0, uri: nil, version: nil) = super
      end
    end
  end
end
