# frozen_string_literal: true

require "core"
require "refinements/time"

module Terminus
  module Structs
    # The extension struct.
    class Extension < DB::Struct
      WEEK = %w[sunday monday tuesday wednesday thursday friday saturday].freeze

      using Refinements::Time

      def export_attributes
        {
          name:,
          label:,
          description:,
          mode:,
          kind:,
          tags:,
          static_body:,
          fields:,
          data:,
          interval:,
          unit:,
          days:,
          last_day_of_month:,
          start_at: start_at.rfc_3339
        }
      end

      def liquid_attributes
        {"label" => label, "fields" => fields, "values" => field_values, "data" => data}
      end

      def screen_label = "Extension #{label}"

      def screen_name = "extension-#{name}"

      def screen_attributes = {extension_id: id, label: screen_label, name: screen_name, mode:}

      def to_cron croner: Aspects::Croner, week: WEEK
        case self
          in unit: "week" then croner.call days.map { week.index it }, unit, time: start_at
          in unit: "month", last_day_of_month: true
            croner.call "#{interval}L", unit, time: start_at
          else croner.call interval, unit, time: start_at
        end
      end

      def to_schedule
        return [screen_name, Core::EMPTY_HASH] if unit == "none"

        [
          screen_name,
          {
            cron: to_cron,
            class: Terminus::Jobs::Batches::Extension.name,
            args: [id],
            description: "The #{label} extension update schedule."
          }
        ]
      end

      private

      def field_values
        return Core::EMPTY_HASH unless fields.is_a? Array
        return Core::EMPTY_HASH unless fields.all? Hash

        fields.each.with_object({}) do |item, all|
          key, value = item.values_at "keyname", "default"
          all[key] = Hash(data).dig("values", key) || value
        end
      end
    end
  end
end
