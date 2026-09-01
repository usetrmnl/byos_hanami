# frozen_string_literal: true

require "tzinfo"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        DaysAgo = lambda do |value, zone = "Etc/UTC", timezone: TZInfo::Timezone|
          timezone.get(zone).now.to_date - value.to_i
        end
      end
    end
  end
end
