# frozen_string_literal: true

module Terminus
  module Aspects
    module Extensions
      DEFAULTS = {
        tags: [],
        mode: "light",
        kind: "poll",
        verb: "get",
        start_at: Time.now.strftime("%Y-%m-%dT00:00:00"),
        days: [],
        interval: 1,
        template: <<~BODY
          <div class="{{model.css_screen_classes}}">
            <div class="view view--full">
              <div class="layout">
              </div>
            </div>
          </div>
        BODY
      }.freeze
    end
  end
end
