# frozen_string_literal: true

Hanami.app.register_provider :liquid, namespace: true do
  prepare { require "liquid" }

  start do
    default = Liquid::Environment.build { it.error_mode = :strict }

    renderer = lambda do |template, data, environment: default|
      Liquid::Template.parse(template, environment:).render data
    end

    register :default, renderer
  end
end
