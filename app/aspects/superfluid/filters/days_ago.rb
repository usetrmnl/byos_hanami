# frozen_string_literal: true

require "tzinfo"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        DaysAgo = lambda do |value, timezone = "Etc/UTC", info: TZInfo::Timezone|
          info.get(timezone).now.to_date - value.to_i
        end
      end
    end
  end
end
