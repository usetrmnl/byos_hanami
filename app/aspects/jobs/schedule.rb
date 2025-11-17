# frozen_string_literal: true

module Terminus
  module Aspects
    module Jobs
      # Manages job schedules.
      class Schedule
        include Deps[:sidekiq]

        def upsert name, configuration, old_name: nil
          delete old_name if old_name && old_name != name
          sidekiq.set_schedule name, configuration
        end

        def delete(name) = sidekiq.remove_schedule name
      end
    end
  end
end
