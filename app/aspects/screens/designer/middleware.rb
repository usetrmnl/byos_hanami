# auto_register: false
# frozen_string_literal: true

require "initable"

require_relative "event_stream"

module Terminus
  module Aspects
    module Screens
      module Designer
        # Streams Server Side Events (SSE) for device screen previews.
        class Middleware
          include Initable[
            %i[req application],
            %i[keyreq pattern],
            headers: {
              "Content-Encoding" => "identity",
              "Content-Type" => "text/event-stream",
              "Cache-Control" => "no-cache",
              "X-Accel-Buffering" => "no"
            },
            event_stream: EventStream
          ]

          def call environment
            request = Rack::Request.new environment
            path = request.path

            case path.match pattern
              in name: then [200, headers, event_stream.new(name)]
              else application.call environment
            end
          end
        end
      end
    end
  end
end
