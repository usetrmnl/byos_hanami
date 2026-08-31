# frozen_string_literal: true

require "core"
require "redcarpet"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        # Transforms Markdown to HTML.
        class Markdown
          def initialize renderer: Redcarpet::Render::HTML.new(Core::EMPTY_HASH),
                         client: Redcarpet::Markdown
            @renderer = renderer
            @client = client.new renderer, Core::EMPTY_HASH
          end

          def call(content) = client.render String(content)

          private

          attr_reader :renderer, :client
        end
      end
    end
  end
end
