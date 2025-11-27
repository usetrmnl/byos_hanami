# frozen_string_literal: true

Hanami.app.register_provider :liquid, namespace: true do
  prepare { require "liquid" }

  start do
    # Register custom filters
    default = Liquid::Environment.build do |env|
      env.error_mode = :strict
      env.register_filter Terminus::Aspects::LiquidJSONFilter
    end

    renderer = lambda do |template, data, environment: default|
      Liquid::Template.parse(template, environment:).render data
    end

    register :default, renderer
  end
end
