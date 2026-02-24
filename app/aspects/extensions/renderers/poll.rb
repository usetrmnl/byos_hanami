# frozen_string_literal: true

require "dry/core"
require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render remote data.
        class Poll
          include Deps[fetcher: "aspects.extensions.multi_fetcher", renderer: "liquid.default"]
          include Dry::Monads[:result]

          # :reek:DuplicateMethodCall
          def call extension, context: Dry::Core::EMPTY_HASH
            template = extension.template

            fetcher.call(extension)
                   .either -> capsule { success template, context.merge(capsule.content), capsule },
                           -> capsule { failure template, context.merge(capsule.content), capsule }
          end

          private

          def success template, context, capsule
            Success capsule.with(content: renderer.call(template, context))
          end

          def failure template, context, capsule
            Failure capsule.with(content: renderer.call(template, context))
          end
        end
      end
    end
  end
end
