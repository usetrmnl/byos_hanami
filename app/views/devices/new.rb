# frozen_string_literal: true

module Terminus
  module Views
    module Devices
      # The new view.
      class New < Terminus::View
        include Deps[builder: "aspects.devices.builder"]

        expose :device
        expose(:fields) { builder.call }
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
