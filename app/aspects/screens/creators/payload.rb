# auto_register: false
# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      module Creators
        # Defines payload for use in creating screens.
        Payload = Data.define :model, :name, :label, :content do
          def attributes = {model_id: model.id, name:, label:}

          def filename = (%(#{name}.#{model.mime_type.split("/").last}) if model)
        end
      end
    end
  end
end
