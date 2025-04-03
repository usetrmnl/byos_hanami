# frozen_string_literal: true

require "ferrum"

module Terminus
  module Screens
    # Saves web page as screenshot.
    class Screensaver
      SETTINGS = {
        browser_options: {
          "disable-dev-shm-usage" => nil,
          "disable-gpu" => nil,
          "hide-scrollbar" => nil,
          "no-sandbox" => nil
        },
        js_errors: true
      }.freeze

      VIEWPORT = {width: 800, height: 480, scale_factor: 1}.freeze

      def initialize settings: SETTINGS, browser: Ferrum::Browser
        @settings = settings
        @browser = browser
      end

      def call content, path, viewport: VIEWPORT
        save content, path, viewport
        path
      end

      private

      attr_reader :settings, :browser

      def save content, path, viewport
        browser.new(settings).then do |instance|
          instance.create_page
          instance.set_viewport(**viewport)
          instance.execute "document.documentElement.innerHTML = `#{content}`;"
          instance.network.wait_for_idle
          instance.screenshot path: path.to_s
          instance.quit
        end
      end
    end
  end
end
