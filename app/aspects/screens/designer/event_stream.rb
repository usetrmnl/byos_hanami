# auto_register: false
# frozen_string_literal: true

require "initable"

module Terminus
  module Aspects
    module Screens
      module Designer
        # Renders device preview image event streams.
        class EventStream
          include Deps[:assets, :logger, repository: "repositories.screen"]
          include Initable[%i[req name], kernel: Kernel]

          def each
            kernel.loop do
              yield <<~CONTENT
                event: preview
                data: #{load_screen}

              CONTENT

              kernel.sleep 1
            end
          end

          private

          def load_screen
            repository.find_by(name:).then do |screen|
              screen ? render_preview(screen) : render_loader
            end
          end

          def render_preview screen
            width, height = screen.image_attributes[:metadata].values_at :width, :height
            path = screen.image_uri

            debug path
            %(<img src="#{path}" alt="Preview" class="image" width="#{width}" height="#{height}"/>)
          end

          def render_loader
            path = assets["loader.svg"].path

            debug path
            %(<img src="#{path}" alt="Loader" class="image" width="800" height="480"/>)
          end

          def debug path
            logger.debug { "Streaming: #{path}." }
          end
        end
      end
    end
  end
end
