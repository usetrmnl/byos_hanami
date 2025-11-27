# frozen_string_literal: true

Hanami.app.register_provider :liquid, namespace: true do
  prepare { require "liquid" }

  start do
    default = Liquid::Environment.build do |environment|
      environment.error_mode = :strict
      environment.register_filter Terminus::Aspects::Liquid::Filters
    end

    renderer = lambda do |template, data, environment: default|
      Liquid::Template.parse(template, environment:).render data
    end

    register :default, renderer
  end
end
