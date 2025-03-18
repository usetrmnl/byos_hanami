# frozen_string_literal: true

require "htmx"
require "refinements/hash"

module Terminus
  module Views
    # The view helpers.
    module Helpers
      extend Hanami::View::Helpers::TagHelper

      using Refinements::Hash

      module_function

      def device_new
        path = routes.path :devices_new

        link_to(
          "New",
          path,
          class: "button button-new",
          **HTMX[
            get: path,
            trigger: "click, keyup[ctrlKey&&key=='n'] from:body",
            target: ".devices",
            swap: "beforeend settle:0.1s"
          ]
        )
      end

      def device_form_cancel path
        tag.input(
          type: :button,
          value: "Cancel",
          class: :decline,
          **HTMX[
            get: path,
            trigger: "click",
            target: "closest .device",
            swap: "outerHTML swap:0s"
          ]
        )
      end

      def device_form_remove
        tag.input type: :button, value: "Cancel", class: :decline, data: {remove: true}
      end

      def device_save verb, path
        tag.input(
          type: :submit,
          value: "Save",
          class: :accept,
          **HTMX[
            verb => path,
            trigger: "click, keyup[ctrlKey&&key=='s'] from:closest .device",
            target: "closest .device",
            swap: "outerHTML swap:0s"
          ]
        )
      end

      def field_for key, attributes, record = nil
        return attributes[key] unless record

        attributes.fetch_value key, record.public_send(key)
      end

      def human_at(at) = at.strftime "%B %d %Y at %H:%M %Z"
    end
  end
end
