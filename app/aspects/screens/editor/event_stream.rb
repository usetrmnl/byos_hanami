# auto_register: false
# frozen_string_literal: true

require "mini_magick"

module Terminus
  module Aspects
    module Screens
      module Editor
        # Renders device preview image event streams.
        class EventStream
          include Deps[:settings]
          include Initable[%i[req id], type: :png, imager: MiniMagick::Image, kernel: Kernel]

          def each
            kernel.loop do
              yield <<~CONTENT
                event: preview
                data: #{image_for "/assets/previews/#{id}.#{type}", image_path}

              CONTENT

              kernel.sleep 1
            end
          ensure
            image_path.delete if image_path.exist?
          end

          private

          def image_path = settings.previews_root.join "#{id}.#{type}"

          def image_for uri, path
            return rendered_image uri, path if path.exist?

            %(<img src="/assets/screen_preview.svg" alt="Loader" class="image" ) +
              %(width="800" height="480"/>)
          end

          def rendered_image uri, path
            width, height = imager.open(path).dimensions

            %(<img src="#{uri}?#{path.mtime.to_i}" alt="Preview" class="image" ) +
              %(width="#{width}" height="#{height}"/>)
          end
        end
      end
    end
  end
end
