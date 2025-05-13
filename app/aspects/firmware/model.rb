# auto_register: false
# frozen_string_literal: true

module Terminus
  module Aspects
    module Firmware
      # Models firmware information.
      Model = Data.define :path, :size, :uri, :version, :modified_at do
        def initialize(path: nil, size: 0, uri: nil, version: nil, modified_at: Time.now) = super
      end
    end
  end
end
