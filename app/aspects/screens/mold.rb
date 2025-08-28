# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      # Defines the mold in which to convert (cast) a screen.
      Mold = Struct.new(
        :model_id,
        :name,
        :label,
        :content,
        :kind,
        :mime_type,
        :bit_depth,
        :colors,
        :rotation,
        :offset_x,
        :offset_y,
        :width,
        :height,
        :input_path,
        :output_path
      ) do
        def self.for(
          model,
          keys: %i[mime_type bit_depth colors rotation offset_x offset_y width height].freeze,
          **
        )
          new(model_id: model.id, **model.to_h.slice(*keys), **)
        end

        def crop = "#{dimensions}+#{offset_x}+#{offset_y}"

        def cropable? = !offset_x.zero? || !offset_y.zero?

        def dither = kind == :text ? "None" : "FloydSteinberg"

        def dimensions = "#{width}x#{height}"

        def filename = %(#{name}.#{mime_type.split("/").last})

        def image_attributes = {model_id:, name:, label:}

        def rotatable? = rotation.positive?
      end
    end
  end
end
