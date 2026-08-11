# frozen_string_literal: true

require "dry/monads"
require "initable"
require "refinements/hash"

module Terminus
  module Aspects
    module Extensions
      module Importers
        module Remote
          module Transformers
            # Transforms (mutates) attributes for initialization.
            class Keys
              include Dry::Monads[:result]

              using Refinements::Hash

              include Initable[
                map: {
                  custom_fields: :fields,
                  id: :external_id,
                  name: :label,
                  polling_body: :poll_body,
                  polling_headers: :poll_headers,
                  polling_url: :poll_template,
                  polling_verb: :poll_verb,
                  refresh_interval: :interval
                },
                deletes: %i[dark_mode]
              ]

              def call attributes
                deletes.each { attributes.delete it }
                attributes.transform_keys! map
                Success attributes
              end
            end
          end
        end
      end
    end
  end
end
