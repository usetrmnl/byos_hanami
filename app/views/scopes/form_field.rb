# frozen_string_literal: true

require "dry/core"
require "refinements/array"

module Terminus
  module Views
    module Scopes
      # Groups form label and input together as a single form field.
      class FormField < Hanami::View::Scope
        using Refinements::Array

        def alpine
          return unless locals.key? :alpine

          locals[:alpine].transform_keys! { "x-#{it}" }
                         .map { |key, value| %(#{key}="#{value}") }
                         .join(" ")
                         .then { %( #{it}) }
        end

        def toggle_error kind = "form-field"
          errors.fetch(key, Dry::Core::EMPTY_ARRAY).any? ? [kind, "error"].compact.join(" ") : kind
        end

        def error_message
          return Dry::Core::EMPTY_STRING unless locals.key? :errors
          return Dry::Core::EMPTY_STRING unless errors.key? key

          errors[key].to_sentence
        end

        def render(path = "shared/form_field") = super
      end
    end
  end
end
