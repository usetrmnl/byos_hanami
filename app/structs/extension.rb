# frozen_string_literal: true

require "dry/core"

module Terminus
  module Structs
    # The extension struct.
    class Extension < DB::Struct
      def screen_label = "Extension #{label}"

      def screen_name = "extension-#{name}"

      def screen_attributes = {label: screen_label, name: screen_name}

      def to_cron(croner: Aspects::Croner) = croner.call interval, unit, time: start_at

      def to_schedule
        [
          screen_name,
          {
            cron: to_cron,
            class: Terminus::Jobs::Batches::Extension,
            args: [id],
            description: "The #{label} extension update schedule."
          }
        ]
      end
    end
  end
end
