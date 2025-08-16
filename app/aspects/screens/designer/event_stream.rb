# auto_register: false
# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      module Designer
        # Renders device preview image event streams.
        class EventStream
          include Deps[repository: "repositories.screen"]
          include Initable[%i[req name], kernel: Kernel]

          def each at: Time.now.to_i
            kernel.loop do
              yield <<~CONTENT
                event: preview
                data: #{load_screen at}

              CONTENT

              kernel.sleep 1
            end
          end

          private

          def load_screen at
            screen = repository.find_by(name:)

            if screen
              width, height = screen.image_attributes[:metadata].values_at :width, :height

              %(<img src="#{screen.image_uri}?#{at}" alt="Preview" class="image" ) +
                %(width="#{width}" height="#{height}"/>)
            else
              %(<img src="/assets/loader.svg" alt="Loader" class="image" ) +
                %(width="800" height="480"/>)
            end
          end
        end
      end
    end
  end
end
