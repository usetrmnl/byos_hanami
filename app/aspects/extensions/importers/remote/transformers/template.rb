# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Extensions
      module Importers
        module Remote
          module Transformers
            # Transforms (mutates) the full Liquid template for initialization.
            class Template
              include Dry::Monads[:result]

              include Initable[
                key_map: {
                  "trmnl.plugin_settings.custom_fields_values" => "extension.values",
                  "trmnl.plugin_settings.custom_fields[0]" => "extension.fields[0]"
                },
                pattern: /
                  (?<prefix>IDX)  # Prefix
                  _               # Delimiter
                  (?<index>\d+)   # Index
                /mx,
                layout: <<~BODY
                  <div class="screen screen--{{model.bit_depth}}bit screen--{{model.name}} screen--lg screen--{{model.orientation}} screen--1x">
                    <div class="view view--full">
                      %<content>s
                    </div>
                  </div>
                BODY
              ]

              def call attributes, content
                uris content
                fields content

                Success attributes.merge!(template: format(layout, content:))
              end

              private

              def uris content, offset: 1
                content.gsub! pattern do
                  captures = Regexp.last_match.named_captures
                  "source_#{captures["index"].to_i + offset}"
                end
              end

              def fields content
                key_map.each { |trmnl, terminus| content.gsub! trmnl, terminus }
              end
            end
          end
        end
      end
    end
  end
end
