# frozen_string_literal: true

require "containable"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        # Registers dependencies.
        module Container
          extend Containable

          register :append_random, AppendRandom
          register :days_ago, DaysAgo
          register :find_by, FindBy
          register :parse_json, FromJSON
          register :group_by, GroupBy

          register(:l_date) { LocalizeDate.new }
          register(:l_word) { LocalizeWord.new }

          register :map_to_i, MapToI
          register(:markdown_to_html) { Markdown.new }
          register(:number_to_currency) { NumberToCurrency.new }
          register(:number_with_delimiter) { NumberWithDelimiter.new }
          register(:ordinalize) { Ordinalize.new }
          register :pluralize, Pluralize
          register :qr_code, QRCode
          register :random_number, RandomNumber
          register :sample, Sample
          register :json, ToJSON
        end
      end
    end
  end
end
