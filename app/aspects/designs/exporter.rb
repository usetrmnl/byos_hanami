# frozen_string_literal: true

require "yaml"

module Terminus
  module Aspects
    module Designs
      # Exports a design for sharing.
      class Exporter
        include Deps[:settings, "aspects.zipper"]

        def call screen_template
          manifest = {
            "configuration.yml" => configuration_for(screen_template),
            "index.html.liquid" => screen_template.content
          }

          zipper.call manifest
        end

        private

        def configuration_for screen_template
          YAML.dump build_configuration(screen_template), stringify_names: true
        end

        def build_configuration screen_template
          {version: settings.git_tag, **screen_template.export_attributes}
        end
      end
    end
  end
end
