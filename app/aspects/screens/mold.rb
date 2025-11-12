# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      MOLD_MODEL_KEYS = %i[
        mime_type
        bit_depth
        colors
        rotation
        offset_x
        offset_y
        width
        height
      ].freeze

      # Defines the mold in which to convert (cast) a screen.
      Mold = Struct.new(
        :model_id,
        :name,
        :label,
        :content,
        :kind,
        *MOLD_MODEL_KEYS,
        :input_path,
        :output_path
      ) do
        def self.for(model, keys: MOLD_MODEL_KEYS, **)
          new(model_id: model.id, **model.to_h.slice(*keys), **)
        end

        def crop = "#{dimensions}+#{offset_x}+#{offset_y}"

        def cropable? = !offset_x.zero? || !offset_y.zero?

        def dither = kind == :text ? "None" : "FloydSteinberg"

        def dimensions = "#{width}x#{height}"

        def filename = %(#{name}.#{mime_type.split("/").last})

        def image_attributes = {model_id:, name:, label:}

        def rotatable? = rotation.positive?

        def viewport = {width:, height:}
      end
    end
  end
end
