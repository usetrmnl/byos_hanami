# frozen_string_literal: true

require "hanami/view"
require "initable"
require "refinements/string"

module Terminus
  module Views
    module Parts
      # The extension exchange presenter.
      class Exchange < Hanami::View::Part
        include Deps["aspects.extensions.curler", "aspects.extensions.exchanges.request_builder"]
        include Initable[json_formatter: Aspects::JSONFormatter]

        using Refinements::String

        def curl(extension) = curler.call extension, value

        def formatted_body = json_formatter.call body

        def formatted_data = json_formatter.call data

        def formatted_errors = json_formatter.call errors

        def formatted_headers = json_formatter.call headers

        def formatted_verb = verb.upcase

        def requests extension, length = 50
          request_builder.call(value, extension).map { it.uri.trim_end length }
        end

        def status
          span = helpers.tag.method :span

          if errors.empty?
            span.call "Success", class: "bit-pill bit-pill-active"
          else
            span.call "Failure", class: "bit-pill bit-pill-alert"
          end
        end
      end
    end
  end
end
